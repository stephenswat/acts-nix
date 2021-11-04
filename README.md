# Acts Nix derivations

This repository contains a bunch of Nix derivations for Acts. In Nix
terminology, a derivation is a recipe for building a certain package. They can
be easily made to depend on each other, and so we can build much simpler, and
more reproducible, builds.

These derivations are presented as a very simple channel, which means that they
are source of derivations for Nix. We achieve this by blatantly abusing some
Github features in order to make these files publically available.

## Goals

This repository has four goals:

1. Reduce the amount of dependency hell that plagues all of the different Acts
   R&D projects.
2. Reduce the amount of code that needs to be pulled in at configuration time,
   because that mechanism is unpredictable, very fragile, and can take a lot of
   time.
3. Make the building of Acts software more reproducible.
4. Make it easier to set up build environments for people joining the projects.

## Using these derivations

The first step in using these derivations is to install Nix. Nix is a package
manager (there is also an operating system, which we do not need to use).
Installing and uninstalling Nix is relatively easy, you can find a tutorial at
[the Nix website](https://nixos.org/download.html).

Once you have installed Nix, you will need to add this channel to your channel
list, which is done as follows:

```
$ nix-channel --add https://github.com/stephenswat/acts-nix/archive/refs/heads/nixexprs.tar.gz acts
```

You may then need to update your channel to pull in the derivations:

```
$ nix-channel --update
```

Now, let's go ahead and set up a detray environment, just as an example:

```
$ nix-shell -p "let acts = import <acts>; in acts.detray"
```

That's all there is to it! You are now in a shell that has detray installed,
and all of its dependencies. You can do all of your detray development in this
environment and you can be sure that your results will be totally reproducible.

All derivations in this repository are designed to be pure, which is to say
they do not require anything to be installed on your own system. You can open a
pure shell using the following command:

```
$ nix-shell --pure -p "let acts = import <acts>; in acts.detray"
```

## Derivations included

Currently, this repository includes derivations for:

* vecmem
* Algebra plugins
* detray
* Acts
* dfelibs
* traccc

However, some of these are still work-in-progress.
