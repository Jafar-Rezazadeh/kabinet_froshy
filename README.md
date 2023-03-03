# kabinet_froshy

### Windows platform application made by flutter framework(Dart Language)
## Made by Jafar.Rezazadeh, contact me: https://jafarrezazadeh76@gmail.com

### Preview


https://user-images.githubusercontent.com/59100135/214051072-b0adefc6-5f7a-459c-a41c-65eab87ddf5b.mp4




### how to use:

** fist of all the main folder should be named kabinet_froshy **
if you download a zip file of this project and extract it, if the folder name is ```kabinet_froshy-main``` or any thing else change it to ```kabinet_froshy``` and then follow the steps.

### you need to connect to internet (if you need vpn, use it :])

#### open the commandline(cmd) and go inside the kabinet_froshy folder then run this commands:

- #### step 1: run the ``` flutter pub get ```

- #### step 2: run the ``` flutter create --platforms=windows .``` 
- the above command will create a folder called Windows

- #### step 3: go to ``` windows/runner/main.cpp ``` and add this code on top of the file

```
#include <bitsdojo_window_windows/bitsdojo_window_plugin.h>
auto bdw = bitsdojo_window_configure(BDW_CUSTOM_FRAME | BDW_HIDE_ON_STARTUP);
```

- #### step 4: run the ``` flutter run ```

that's it you run the project.


## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
