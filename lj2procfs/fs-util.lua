local ffi = require("ffi")

local libc = require("lj2procfs.libc")
local sutil = require("lj2procfs.string-util")

function hidden_file_allow_backup(filename)
    if not filename then return false end

    return
        sutil.startswith(filename, '.') or
        filename == "lost+found" or
        filename == "aquota.user" or
        filename == "aquota.group" or
        sutil.endswith(filename, ".rpmnew") or
        sutil.endswith(filename, ".rpmsave") or
        sutil.endswith(filename, ".rpmorig") or
        sutil.endswith(filename, ".dpkg-old") or
        sutil.endswith(filename, ".dpkg-new") or
        sutil.endswith(filename, ".dpkg-tmp") or
        sutil.endswith(filename, ".dpkg-dist") or
        sutil.endswith(filename, ".dpkg-bak") or
        sutil.endswith(filename, ".dpkg-backup") or
        sutil.endswith(filename, ".dpkg-remove") or
        sutil.endswith(filename, ".swp");
end

function isHiddenFile(filename)
    if not filename then return false; end

    if sutil.endswith(filename, "~") then
        return true;
    end

    return hidden_file_allow_backup(filename);
end


--[[
local function isDirectory(entry)
    return entry.Kind == libc.DT_DIR and 
        entry.Name ~= '.' and
        entry.Name ~= '..'
end
--]]

local function isDirectory(path)
    local adir = libc.opendir(path);
    local res = adir ~= nil
    if adir ~= nil then
        libc.closedir(adir)
    end

    return res;
end


local function isFile(path)
    local fd = io.open(path)
    local fdtype = io.type(fd);
    print("FD TYPE: ", path, fdtype)
    local res = fdtype == "file"
    fd:close();

    return res;
end

--[[
local function dirent_ensure_type(DIR *d, struct dirent *de)
        struct stat st;

        assert(d);
        assert(de);

        if (de.d_type != libc.DT_UNKNOWN)
                return 0;

        if (fstatat(dirfd(d), de->d_name, &st, AT_SYMLINK_NOFOLLOW) < 0)
                return -errno;

        de->d_type =
                S_ISREG(st.st_mode)  ? DT_REG  :
                S_ISDIR(st.st_mode)  ? DT_DIR  :
                S_ISLNK(st.st_mode)  ? DT_LNK  :
                S_ISFIFO(st.st_mode) ? DT_FIFO :
                S_ISSOCK(st.st_mode) ? DT_SOCK :
                S_ISCHR(st.st_mode)  ? DT_CHR  :
                S_ISBLK(st.st_mode)  ? DT_BLK  :
                                       DT_UNKNOWN;

        return 0;
end
--]]

local function dirent_is_file(de)
    if de == nil then return false; end

    if isHiddenFile(ffi.string(de.d_name)) then
        return false;
    end

    if (de.d_type ~= libc.DT_REG and
            de.d_type ~= libc.DT_LNK and
            de.d_type ~= libc.DT_UNKNOWN) then
                return false;
    end

    return true;
end

--[[
local function  dirent_is_file_with_suffix(const struct dirent *de, const char *suffix)
        assert(de);

        if (de.d_type ~= libc.DT_REG and
            de.d_type ~= libc.DT_LNK and
            de.d_type ~= libc.DT_UNKNOWN) then
                return false;
        end

        if (isHiddenFile_allow_backup(de.d_name)) then
                return false;
        end

        return endswith(de.d_name, suffix);
end
--]]

local function nil_iter()
    return nil;
end

local function iterate_files_in_directory(path)
    local dir = libc.opendir(path)

    if not dir==nil then return nil_iter, nil, nil; end

    -- This is a 'generator' which will continue
    -- the iteration over files
    local function gen_files(dir, state)
        local de = nil

        while true do
            de = libc.readdir(dir)
    
            -- if we've run out of entries, then return nil
            if de == nil then return nil end

            --dirutil.dirent_ensure_type(d, de);

            -- check the entry to see if it's an actual file, and not
            -- a directory or link
            if dirent_is_file(de) then
                break;
            end
        end

        local entry = {
            Name = ffi.string(de.d_name);
            Kind = de.d_type;
            INode = de.d_ino;
        }
        entry.Path = path..'/'..entry.Name;

        return state, entry
    end
    
    -- make sure to do the finalizer
    -- for garbage collection
    ffi.gc(dir, libc.closedir);

    return gen_files, dir, dir;
end

local function entries_in_directory(path)
    local dir = libc.opendir(path)

    if dir==nil then return nil_iter, nil, nil; end


    -- This is a 'generator' which will continue
    -- the iteration over files
    local function gen_entries(dir, state)
        local de = libc.readdir(dir)
        -- if we've run out of entries, then return nil
        if de == nil then return nil end

        local entry = {
            Name = ffi.string(de.d_name);
            Kind = de.d_type;
            INode = de.d_ino;
        }
        entry.Path = path..'/'..entry.Name;

        return state, entry
    end

    -- make sure to do the finalizer
    -- for garbage collection
    --ffi.gc(dir, libc.closedir);

    return gen_entries, dir, dir;
end


local exports = {
    files_in_directory = iterate_files_in_directory;
    entries_in_directory = entries_in_directory;

    dirent_is_file = dirent_is_file;

    isDirectory = isDirectory;
    isFile = isFile;
    isHiddenFile = isHiddenFile
}

return exports
