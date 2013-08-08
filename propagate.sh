#! /bin/sh

### helpers
#log() { `dirname "$0"`/common/log "$@"; }
#
#log_error() { log error "$1"; }
#log_info()  { log info  "$1"; }
#log_warn()  { log warn  "$1"; }
#
#
### display usage
#usage() {
  #log_info "usage: propagate [-h] source_file destinations..."
  #log_info ""
  #log_info "this script propagates a copy of a file to multiple destinations"
  #log_info ""
  #log_info "arguments:"
  #log_info "  source_file"
  #log_info "    the source to copy from"
  #log_info "  destinations"
  #log_info "    the destination locations"
  #log_info ""
  #log_info "options:"
  #log_info "  -h"
  #log_info "    display the usage information"
#
  #exit 0
#}
#
### main
## determine what to list based on provided arguments
#while test $# -gt 0
#do
  #case $1 in
    ## normal option processing
    #-h | --help)    usage ;;
    #-v | --version) usage ;;
#
    ## special cases
    #--)  break ;;
    #--*)       ;; # error unknown (long) option $1
    #-?)        ;; # error unknown (short) option $1
#
    ## split apart combined short options
    #-*)
      #split=$1
      #shift
      #set -- $(echo "$split" | cut -c 2- | sed 's/./-& /g') "$@"
      #continue
      #;;
#
    ## done with options
    #*) break ;;
  #esac
#
  #shift
#done
#
#if test $# -lt 2
#then
  #log_error "supply a minimum of 2 arguments"
  #exit 1
#fi
#
#source_file=$1
#shift
#
#while test $# -gt 0
#do
  #log_info "copy $source_file to $1"
  #scp $source_file $1
  #shift
#done
#
#exit 0
#
