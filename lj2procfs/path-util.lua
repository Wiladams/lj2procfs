local sutil = require("lj2procfs.string-util")

local F = {}

function F.hidden_file_allow_backup(filename)
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

function F.hidden_file(filename)
    if not filename then return false; end

    if sutil.endswith(filename, "~") then
        return true;
    end

    return F.hidden_file_allow_backup(filename);
end


return F
