vimconfig
=========

My vimconfiguration and plugins.

I load plugins using pathogen and hookup my plugins as submodules in the bundle directory. To use a plugin in a certain environment I initialize submodules when I require certain plugins.

To add a plugin to vim using a setup like this:
git submodule add https://somegitrepo.com/myfancyplugin/ 

