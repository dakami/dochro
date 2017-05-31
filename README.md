# dochro
Full Web-Based Chrome Development Environment

# Quickstart

    $ git clone https://github.com/dakami/dochro
    $ cd dochro
    $ docker build -t dochro .
    ### come back in many hours, and I've only tested on +64G of memory
    ### Unsure if requires root, sure requires SYS_PTRACE for gdb to function
    # docker run --rm --cap-add=SYS_PTRACE -it -p 127.0.0.1:40080:8080 dochro
    
    # now navigate browser to 127.0.0.1:40080 (use ssh -L40080:127.0.0.1:40080 $SERVER if remote)
![dochro screen shot](/dochro1.png "")
![dochro screen shot](/dochro2.png "")

#TODO

1. Custom registry (on each cloud?) to support enormous images
2. Eliminate prompting for session / integrate with Autoclave /
   swap XRDP out / fix double window manager issues
3. Host more than just Chromium, and add a way to build a smaller
   Chromium image (build flags, most likely).  Alternate useful environments:
   1. Firefox
   2. Linux
   3. QEMU
   4. Eclipse
4. Integrate patch submission -- we can find the bugs, we can fix the bugs,
   one more step is submitting patches (or at least, extracting diffs).
5. More languages!  Liclipse license doesn't really afford just dropping it
   into this environment, but Eclipse can actually be fairly fast (at least
   given cloud scale resources) and we can give people something more than
   Cloud9
6. Why not give people Cloud9 too? 
7. Something like "docker build --build-arg GIT=https://github.com/dakami/autoclave" doclave ."
   would be pretty cool -- effectively, declare what you want to work on, get
   a fully configured dev environment.
8. Oh, there's lots to do to clean things up after build.  Basically "workspace2"
   needs a bunch of polish to actually launch content_shell correctly, chrome,
   etc.  Should we build both debug and release?
9. Parallelize Eclipse CDT indexer, possibly with omp4j.  It *seems* like
   PDOM can be parallelized.  Alternatively, replace the backing store with
   an actual database, possibly a graph database.  GPU backed databases are
   fairly absurd, and it'd be good to demonstrate that.  Neo4J and Alenka
   are interesting here (the latter is C++/GPU only, but it's hilariously
   fast).
10. Work out what requires root, what requires SYS_PTRACE, and actually tell
    people rather than forcing them to guess.  See if Clear Containers as is
    allows less ... surprising semantics, or could.
11. Work out *actual* required memory, for builds and operational environments.

