 package = "lj2procfs"
 version = "0.1-5"
 source = {
    url = "https://github.com/wiladams/lj2procfs/archive/v0.1-5.tar.gz",
    dir = "lj2procfs-0.1-5",
 }
 description = {
    summary = "LuaJIT access to the Linux procfs",
    detailed = [[
       This module gives you ready access to the procfs file system on Linux.  
       This is for Linux ONLY!
    ]],
    homepage = "http://github.com/wiladams/lj2procfs",
    license = "MIT/X11"
 }
 
 supported_platforms = {"linux"}
  
  dependencies = {
    "lua ~> 5.1"
  }

  build = {
    type = "builtin",

    modules = {
      -- general programming goodness
      ["lj2procfs.fs-util"] = "lj2procfs/fs-util.lua",
      ["lj2procfs.fun"] = "lj2procfs/fun.lua",
      ["lj2procfs.libc"] = "lj2procfs/libc.lua",
      ["lj2procfs.platform"] = "lj2procfs/platform.lua",
      ["lj2procfs.print-util"] = "lj2procfs/print-util.lua",
      ["lj2procfs.siginfo"] = "lj2procfs/siginfo.lua",
      ["lj2procfs.string-util"] = "lj2procfs/string-util.lua",
      ["lj2procfs.striter"] = "lj2procfs/striter.lua",

      -- The guts
      ["lj2procfs.Decoders"] = "lj2procfs/Decoders.lua",
      ["lj2procfs.ProcessEntry"] = "lj2procfs/ProcessEntry.lua",
      ["lj2procfs.procfs"] = "lj2procfs/procfs.lua",

      -- codecs for flat files in /proc
      ["lj2procfs.codecs.buddyinfo"] = "lj2procfs/codecs/buddyinfo.lua",
      ["lj2procfs.codecs.cgroups"] = "lj2procfs/codecs/cgroups.lua",
      ["lj2procfs.codecs.cmdline"] = "lj2procfs/codecs/cmdline.lua",
      ["lj2procfs.codecs.cpuinfo"] = "lj2procfs/codecs/cpuinfo.lua",
      ["lj2procfs.codecs.crypto"] = "lj2procfs/codecs/crypto.lua",
      ["lj2procfs.codecs.diskstats"] = "lj2procfs/codecs/diskstats.lua",
      ["lj2procfs.codecs.interrupts"] = "lj2procfs/codecs/interrupts.lua",
      ["lj2procfs.codecs.iomem"] = "lj2procfs/codecs/iomem.lua",
      ["lj2procfs.codecs.ioports"] = "lj2procfs/codecs/ioports.lua",
      ["lj2procfs.codecs.kallsyms"] = "lj2procfs/codecs/kallsyms.lua",
      ["lj2procfs.codecs.loadavg"] = "lj2procfs/codecs/loadavg.lua",
      ["lj2procfs.codecs.meminfo"] = "lj2procfs/codecs/meminfo.lua",
      ["lj2procfs.codecs.modules"] = "lj2procfs/codecs/modules.lua",
      ["lj2procfs.codecs.net"] = "lj2procfs/codecs/net.lua",
      ["lj2procfs.codecs.partitions"] = "lj2procfs/codecs/partitions.lua",
      ["lj2procfs.codecs.softirqs"] = "lj2procfs/codecs/softirqs.lua",
      ["lj2procfs.codecs.sys"] = "lj2procfs/codecs/sys.lua",
      ["lj2procfs.codecs.uptime"] = "lj2procfs/codecs/uptime.lua",
      ["lj2procfs.codecs.vmstat"] = "lj2procfs/codecs/vmstat.lua",

      -- codecs for flat files in /proc/process
      ["lj2procfs.codecs.process.environ"] = "lj2procfs/codecs/process/environ.lua",
      ["lj2procfs.codecs.process.exe"] = "lj2procfs/codecs/process/exe.lua",
      ["lj2procfs.codecs.process.io"] = "lj2procfs/codecs/process/io.lua",
      ["lj2procfs.codecs.process.limits"] = "lj2procfs/codecs/process/limits.lua",
      ["lj2procfs.codecs.process.maps"] = "lj2procfs/codecs/process/maps.lua",
      ["lj2procfs.codecs.process.mounts"] = "lj2procfs/codecs/process/mounts.lua",
      ["lj2procfs.codecs.process.sched"] = "lj2procfs/codecs/process/sched.lua",
      ["lj2procfs.codecs.process.status"] = "lj2procfs/codecs/process/status.lua",

      -- codecs for flat files in /proc/net
      ["lj2procfs.codecs.net.dev"] = "lj2procfs/codecs/net/dev.lua",
      ["lj2procfs.codecs.net.netstat"] = "lj2procfs/codecs/net/netstat.lua",

    },
 }
