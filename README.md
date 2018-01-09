```
###############################################################################################################################################
#                                                                                                                                             #
#   :::::::::: :::::::::  ::::::::::  ::::::::  :::    ::: ::::::::::: ::::    :::  ::::::::  :::::::::::     :::     :::        :::          #
#   :+:        :+:    :+: :+:        :+:    :+: :+:    :+:     :+:     :+:+:   :+: :+:    :+:     :+:       :+: :+:   :+:        :+:          #
#   +:+        +:+    +:+ +:+        +:+        +:+    +:+     +:+     :+:+:+  +:+ +:+            +:+      +:+   +:+  +:+        +:+          #
#   :#::+::#   +#++:++#:  +#++:++#   +#++:++#++ +#++:++#++     +#+     +#+ +:+ +#+ +#++:++#++     +#+     +#++:++#++: +#+        +#+          #
#   +#+        +#+    +#+ +#+               +#+ +#+    +#+     +#+     +#+  +#+#+#        +#+     +#+     +#+     +#+ +#+        +#+          #
#   #+#        #+#    #+# #+#        #+#    #+# #+#    #+#     #+#     #+#   #+#+# #+#    #+#     #+#     #+#     #+# #+#        #+#          #
#   ###        ###    ### ##########  ########  ###    ### ########### ###    ####  ########      ###     ###     ### ########## ##########   #
#                                                                                                                                             #
###############################################################################################################################################
```

# So you want to set up a new Mac aye?

Good, `./freshinstall` will help you out with that.

## Installation

Via Terminal _(maximize the window for the best effect)_:

```
mkdir ~/Downloads/freshinstall
cd ~/Downloads/freshinstall
curl -#L https://github.com/bramus/freshinstall/tarball/master | tar -xzv --strip-components 1 --exclude={LICENSE}
```

## Usage

Also via Terminal:

```
./freshinstall.sh
```

With successive runs, `./freshinstall` will pick up where it left. If you do want to start all over again, use `--force`.

## Steps

1. macOS Defaults **(reboot required)**

	This step will set some (opinionated) macOS defaults.

2. SSH Configuration

	This step will check your SSH Configuration, and create an SSH key if none has been created yet.

3. Essentials

	This step will install some required essentials. These include:

	- Xcode and its Command Line Tools
	- Homebrew
	- Git

	The git installation will also do some basic configuration ;)

4. Dotfiles

	This step will copy over the defined dotfiles. Included things are:

	- A customized prompt
	- Git branch autocompletion
	- Makefile autocompletion

	_Note that these files (`.bash_profile` and such) will be altered in later steps, upon installing specific pieces of software_

5. Software

	Handpicked selection of Software + Config in some cases

## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.

## Credits

- Bram(us) Van Damme <em>([https://www.bram.us/](https://www.bram.us/))</em>
- [All Contributors](../../contributors)

## Resources

- https://github.com/mathiasbynens/dotfiles
- https://github.com/paulirish/dotfiles
- https://github.com/herrbischoff/awesome-osx-command-line
- https://superuser.com/a/1123198
- https://github.com/joeyhoer/starter/blob/master/apps/sublime-text.sh
- https://gist.github.com/agrcrobles/165ac477a9ee51198f4a870c723cd441
- https://github.com/hjuutilainen/dotfiles/tree/master/bin
