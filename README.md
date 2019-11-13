## Building

### [cquery](https://github.com/cquery-project/cquery/wiki)

[Introduction](https://github.com/cquery-project/cquery/wiki/Building-cquery)

1. **build**
```sh
git clone --recursive https://github.com/cquery-project/cquery.git
cd cquery
git submodule update --init
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=release -DCMAKE_EXPORT_COMPILE_COMMANDS=YES
cmake --build .
cmake --build . --target install
```
2. add `cquery/build/bin/` to path 

### [tabnine-vim](https://tabnine.com/)

Should work after clone.

### [grammarous](https://github.com/rhysd/vim-grammarous)

[Introduction](http://www.comrite.com/wp/vim-grammar-check/)
Should work after clone.
