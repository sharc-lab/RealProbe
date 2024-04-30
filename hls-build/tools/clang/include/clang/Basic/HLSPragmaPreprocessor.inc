/*===- TableGen'erated file -------------------------------------*- C++ -*-===*\
|*                                                                            *|
|* Xilinx HLS pragma option preprocessor keyword filter                       *|
|*                                                                            *|
|* Automatically generated file, do not edit!                                 *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/

#include "llvm/ADT/StringRef.h"
#include <map>
#include <set>
namespace hls {
namespace pragma {
static std::map<std::string, std::set<std::string>> HLSPragmaKWFilter = {
	{"axis_interface", {"axis_interface", "register", "register_mode", "forward", "reverse", "off", "both", "forward", "reverse", "both", "off", "depth"}}, 
	{"aggregate", {"aggregate", "variable", "bit", "byte", "none", "auto", "compact", "bit", "byte", "none", "auto"}}, 
	{"alias", {"alias", "ports", "offset", "distance"}}, 
	{"allocation", {"allocation", "function", "operation", "type", "operation", "function", "limit", "instances", "instances"}}, 
	{"array_partition", {"array_partition", "variable", "factor", "dim", "block", "cyclic", "complete", "type", "block", "cyclic", "complete", "dynamic"}}, 
	{"array_reshape", {"array_reshape", "variable", "factor", "dim", "block", "cyclic", "complete", "object", "type", "block", "cyclic", "complete"}}, 
	{"array_stencil", {"array_stencil", "variable", "off"}}, 
	{"memory", {"memory", "depth", "latency", "storage_type"}}, 
	{"bind_op", {"bind_op", "variable", "op", "impl", "latency"}}, 
	{"bind_storage", {"bind_storage", "variable", "type", "impl", "latency"}}, 
	{"cache", {"cache", "port", "lines", "depth", "ways", "users", "burst", "off", "on", "write_mode", "write_back", "write_through"}}, 
	{"ap_stable", {"ap_stable"}}, 
	{"data_pack", {"data_pack", "variable", "instance", "struct_level", "field_level", "byte_pad", "struct_level", "field_level"}}, 
	{"dataflow", {"dataflow", "interval", "disable_start_propagation"}}, 
	{"dependence", {"dependence", "cross_variables", "variable", "array", "pointer", "intra", "inter", "raw", "war", "waw", "distance", "true", "false", "class", "array", "pointer", "type", "intra", "inter", "dependent", "true", "false", "direction", "raw", "war", "waw"}}, 
	{"disaggregate", {"disaggregate", "variable"}}, 
	{"expression_balance", {"expression_balance", "off"}}, 
	{"function_allocation", {"function_allocation", "instances"}}, 
	{"function_instantiate", {"function_instantiate", "variable"}}, 
	{"inline", {"inline", "self", "all", "region", "type", "self", "all", "region", "recursive", "off"}}, 
	{"interface", {"interface", "port", "name", "m_axi", "s_axilite", "axis", "ap_memory", "bram", "ap_none", "ap_fifo", "ap_hs", "ap_ack", "ap_vld", "ap_ovld", "ap_stable", "ap_bus", "ap_ctrl_none", "ap_ctrl_hs", "ap_ctrl_chain", "mode", "ap_none", "ap_vld", "ap_ack", "ap_hs", "ap_ovld", "ap_fifo", "ap_memory", "bram", "axis", "s_axilite", "m_axi", "ap_ctrl_none", "ap_ctrl_hs", "ap_ctrl_chain", "ap_stable", "bundle", "depth", "offset", "num_read_outstanding", "num_write_outstanding", "max_read_burst_length", "max_write_burst_length", "latency", "max_widen_bitwidth", "channel", "register", "register_mode", "forward", "reverse", "off", "both", "forward", "reverse", "both", "off", "offset", "clock", "storage_impl", "storage_type", "interrupt"}}, 
	{"ap_stable", {"ap_stable", "register", "depth", "latency", "interrupt"}}, 
	{"latency", {"latency", "min", "max"}}, 
	{"loop_flatten", {"loop_flatten", "off"}}, 
	{"loop_merge", {"loop_merge", "force"}}, 
	{"loop_tripcount", {"loop_tripcount", "min", "max", "avg"}}, 
	{"maxi_interface", {"maxi_interface", "bundle", "depth", "offset", "num_read_outstanding", "num_write_outstanding", "max_read_burst_length", "max_write_burst_length", "latency", "max_widen_bitwidth", "channel"}}, 
	{"occurrence", {"occurrence", "cycle"}}, 
	{"operation_allocation", {"operation_allocation", "instances"}}, 
	{"performance", {"performance", "target_ti", "target_tl", "assume_ti", "assume_tl", "scope", "loop", "region"}}, 
	{"pipeline", {"pipeline", "ii", "rewind", "enable_flush", "off", "style", "stp", "flp", "frp"}}, 
	{"protocol", {"protocol", "floating", "fixed", "mode", "fixed", "floating"}}, 
	{"realprobe", {"realprobe", "self", "all", "region", "type", "self", "all", "region", "recursive", "off"}}, 
	{"reset", {"reset", "variable", "off"}}, 
	{"resource", {"resource", "variable", "core", "ecc_mode", "none", "encode", "decode", "both", "latency", "auto", "distribute", "block", "uram", "memory_style", "auto", "distribute", "block", "uram", "metadata"}}, 
	{"s_axilite", {"s_axilite", "bundle", "offset", "clock", "storage_impl"}}, 
	{"ap_scalar", {"ap_scalar", "register", "depth", "latency"}}, 
	{"shared", {"shared", "variable"}}, 
	{"stable_content", {"stable_content", "variable"}}, 
	{"stable", {"stable", "variable"}}, 
	{"stream", {"stream", "variable", "depth", "dim", "off", "type", "fifo", "pipo", "shared", "unsync"}}, 
	{"top", {"top", "name"}}, 
	{"unroll", {"unroll", "factor", "region", "complete", "partial", "type", "partial", "complete", "region", "skip_exit_check"}}, 
};

static std::string CurPragma = "";

static inline void setCurPragma(llvm::StringRef Name) {
	CurPragma = Name.lower();
}

static inline bool shouldExpandMacro(llvm::StringRef Name) {
	if (HLSPragmaKWFilter.count(CurPragma) == 0) return true;
	std::set<std::string> Filters = HLSPragmaKWFilter[CurPragma];
	return Filters.count(Name.lower()) == 0;
}

static inline void resetCurPragma() {
	CurPragma = "";
}
} // end namespace pragma
} // end namespace hls
