code_dir=$(pwd)
log_file=/tmp/robodhop.log
rm -f ${log_file}

print_head() {
    echo -e "\e[36m$1\e[0m"
}


status_check()
if { $? -eq 0}; then
   echo SUCESS
else
   echo FAILURE
   exit 1
fi
}