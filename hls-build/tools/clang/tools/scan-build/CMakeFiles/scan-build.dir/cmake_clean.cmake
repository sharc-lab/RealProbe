file(REMOVE_RECURSE
  "../../../../bin/scan-build"
  "../../../../libexec/c++-analyzer"
  "../../../../libexec/ccc-analyzer"
  "../../../../share/man/man1/scan-build.1"
  "../../../../share/scan-build/scanview.css"
  "../../../../share/scan-build/sorttable.js"
  "CMakeFiles/scan-build"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/scan-build.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
