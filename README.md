# withlock

## About

`withlock` is a locking wrapper script to make sure that some program isn't run
more than once. It is ideal to prevent periodic jobs spawned by cron from
stacking up.

The locks created are valid only while the wrapper is running, and thus will
*never* require additional cleanup, even after a reboot. This makes the wrapper
safe and easy to use, and much better than implementing half-hearted locking
within scripts.

The wrapper is used in production since summer 2009, and proved to work
reliably since then. In testing, it had showed to be free of race conditions
when used concurrently while the author tried very hard to break it. I guess
there is always some remaining corner for a race, and wouldn't claim a "100%",
but it's definitely good enough and fit for the purpose.


## Features

* locks that never need a cleanup, whatever happens
* can wait a defined time for a lock to become "free"
* disallows lock files in unsafe locations (to prevent symlink attacks)
* easily installed, as portable as Python


## Supported Platforms

withlock has been tested on the following platforms:

* **Debian** Lenny (5.0) and later
* **Ubuntu** Jaunty Jackalope (9.04), Karmic Koala (9.10) and later
* **openSUSE** 10.1, 11.0, 11.1 and later
* **CentOS** 5.4
* **FreeBSD** 8.0
* **OSX** Leopard (10.5), Snow Leopard (10.6)
* **OpenCSW Solaris** http://www.opencsw.org/packages/withlock/

Quite likely, more platforms are supported. Please provide feedback if you know about one.

withlock should run on every platform that has a Python interpreter of version 2.4 or newer. The requirement on Python 2.4 is for the subprocess module, which was introduced with that version.

The most extensive testing has been performed on openSUSE with XFS and ext3 as underlying filesystems. On the other listed platforms, basic functionality has been verified.

## Download

wget http://mirrorbrain.org/files/releases/withlock-0.4.tar.gz


## Simple install of the latest script from git master

    sudo su -
    wget https://raw.githubusercontent.com/poeml/withlock/master/withlock
    chmod +x withlock
    mv withlock /usr/local/bin/


## Usage

Usage is simple. Instead of your command 

    CMD ARGS...

you simply use

    withlock LOCKFILE CMD ARGS...



**Note: the lockfile LOCKFILE must not be placed in a publicly writable
directory, because that would allow a symlink attack. For that reason, withlock
disallows lockfiles in such locations.**

Run `withlock --help` to see more options. Here's an overview:

     # withlock --help
    Usage: withlock [options] LOCKFILE CMD ARGS...
    
    Options:
      --version             show program's version number and exit
      -h, --help            show this help message and exit
      -w SECONDS, --wait=SECONDS
                            wait for maximum SECONDS until the lock is acquired
      -q, --quiet           if lock can't be acquired immediately, silently quit
                            without error
      -v, --verbose         print debug messages to stderr



## cron Examples

Here's an example for cron jobs run under withlock:


    -*/10 * * * *   root     withlock LOCK-serverstatus /usr/bin/log_server_status2
    43 5,17 * * *   mirror   withlock LOCK-rsync-edu-isos rsync -rlptoH --no-motd rsync.opensuse-education.org::download/ISOs/ /srv/mirrors/opensuse-education/ISOs -hi



## History

This wrapper was implemented because no comparable solution was found even after looking around for a long time (and suffering problems caused by missing or insufficient locking for years). The only solution that comes close is with-lock-ex.c, an implementation in C, which was written by Ian Jackson and placed in the public domain by him. with-lock-ex.c is traditionally available on Debian in a package named chiark-utils-bin. Parts of withlock's locking strategy and parts of the usage semantics were inspired from that program. This implementation was chosen to be done in Python because it's universally available, easy to adapt, and doesn't require to be compiled.

Then, somebody pointed out to me that there's `flock(1)`, a small tool written in C that does the same. Indeed, I had apparently managed to miss that tool during a decade's worth of Linux hacking (you discover something new every day, don't you?). The functionality is mainly the same indeed. 

However, withlock has some advantages:

* withlock ist a little easier and logical to use than `flock(1)`. The semantics are more suited for sysadmins.
* withlock always cleans up it's lock files. `flock(1)` always lets them lying around. I admit that I like the fact that with withlock I can always see by the presence of the lock files which jobs are running.
* `flock(1)` doesn't prevent using unsafe directories
* withlock is easily extensible
* it could be used as a Python module (but that's not implemented)
* `flock(1)` doesn't exist on Solaris and OSX


## Possible Features for the Future

* maybe add `--insecure` option to override disallowance lockfiles in publicly
  writable directories
* functionality from withlock(1) that's missing in flock(1) could be
  implemented in the latter
* it would be conceivable to extend the script to allow starting *n* instances
  of a job. That would probably bring about a different locking strategy
  though.
* the script could (should) be packaged for the platforms, or integrated into the base system. Package maintainers, please grab it!


Please provide feedback!
Thanks!


## Revision history


0.5, 2016:

- modernize for Python 2 and 3 compatibility
  thanks to Patch by Jan Beran jberan|redhat.com
  (2.7 or newer; 0.4 for Python 2.4+2.5 is archived in attic/)

0.4, 2015:

- fix lockfile cleanup (Thanks Martin Caj and Martin Vidner. Good Catch!)
  (cosmetical bug which didn't affect the locking strategy)
- man page added
- license file added
- moved to github.com

0.3, 2014:

- At exit, unlink the lock file only if a lock was actually obtained.
  When waiting for a lock (using -w option) and timing out, the file
  was removed nevertheless. Thanks Bernhard Wiedemann for finding this
  bug and providing such a good test case, so the fix was easy.

0.2, 2010:

- prevent possible symlink attacks by disallowing lockfiles in directories
  where users other than the caller have write permissions

0.1, 2009:

- initial release
