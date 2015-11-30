local ffi = require("ffi")

local libc = require("lj2procfs.libc")
local putil = require("lj2procfs.path-util")
local dirutil = require("lj2procfs.dirent-util")


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
            if dirutil.dirent_is_file(de) then
                break;
            end
        end

        local entry = {
            Name = ffi.string(de.d_name);
            Kind = de.d_type;
            INode = de.d_ino;
        }
        entry.Path = path..'/'..entry.Name;

        return de, entry
    end
    
    -- make sure to do the finalizer
    -- for garbage collection
    ffi.gc(dir, libc.closedir);

    return gen_files, dir, initial;
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

        return de, entry
    end

    -- make sure to do the finalizer
    -- for garbage collection
    --ffi.gc(dir, libc.closedir);

    return gen_entries, dir, nil;
end


local exports = {
    files_in_directory = iterate_files_in_directory;
    entries_in_directory = entries_in_directory;
}

return exports
