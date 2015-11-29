
local ffi = require("ffi")
local libc = require("lj2procfs.libc")
local putil = require("lj2procfs.path-util")

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

    if putil.hidden_file(ffi.string(de.d_name)) then
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

        if (de->d_type != DT_REG &&
            de->d_type != DT_LNK &&
            de->d_type != DT_UNKNOWN)
                return false;

        if (hidden_file_allow_backup(de->d_name))
                return false;

        return endswith(de->d_name, suffix);
end
--]]

local exports = {
  dirent_ensure_type = dirent_ensure_type;
  dirent_is_file = dirent_is_file;
}

return exports
