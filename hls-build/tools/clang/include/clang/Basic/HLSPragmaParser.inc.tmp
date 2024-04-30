/*===- TableGen'erated file -------------------------------------*- C++ -*-===*\
|*                                                                            *|
|* Xilinx HLS pragma option parser                                            *|
|*                                                                            *|
|* Automatically generated file, do not edit!                                 *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/

#define PRAGMA_HLS_AXIS_INTERFACE \
                 { \
                     presentId("register", 1), \
                     optEnum("register_mode", {"forward", "reverse", "off", "both"}), \
                     presentId("forward", 2), \
                     presentId("reverse", 2), \
                     presentId("both", 2), \
                     presentId("off", 2), \
                     optICEExpr("depth"), \
                 }

#define PRAGMA_HLS_AGGREGATE \
                 { \
                     reqVarRefExpr("variable"), \
                     presentId("bit", 1), \
                     presentId("byte", 1), \
                     presentId("none", 1), \
                     presentId("auto", 1), \
                     optEnum("compact", {"bit", "byte", "none", "auto"}), \
                 }

#define PRAGMA_HLS_ALIAS \
                 { \
                     reqVarRefExpr("ports"), \
                     optVarRefExpr("offset"), \
                     optVarRefExpr("distance"), \
                 }

#define PRAGMA_HLS_ALLOCATION \
                 { \
                     presentId("function", 1), \
                     presentId("operation", 1), \
                     optEnum("type", {"operation", "function"}), \
                     reqICEExpr("limit"), \
                     optCallBackParser("instances", ParseinstancesOptionForallocation), \
                 }

#define PRAGMA_HLS_ARRAY_PARTITION \
                 { \
                     reqVarRefExpr("variable"), \
                     optICEExpr("factor"), \
                     optICEExpr("dim", 1), \
                     presentId("block", 1), \
                     presentId("cyclic", 1), \
                     presentId("complete", 1), \
                     optEnum("type", {"block", "cyclic", "complete"}), \
                     presentId("dynamic", 0), \
                 }

#define PRAGMA_HLS_ARRAY_RESHAPE \
                 { \
                     reqVarRefExpr("variable"), \
                     optICEExpr("factor"), \
                     optICEExpr("dim", 1), \
                     presentId("block", 1), \
                     presentId("cyclic", 1), \
                     presentId("complete", 1), \
                     presentId("object", 2), \
                     optEnum("type", {"block", "cyclic", "complete"}), \
                 }

#define PRAGMA_HLS_ARRAY_STENCIL \
                 { \
                     reqVarRefExpr("variable"), \
                     presentId("off", 1), \
                 }

#define PRAGMA_HLS_MEMORY \
                 { \
                     optICEExpr("depth", 1), \
                     optICEExpr("latency", -1), \
                     optId("storage_type", "default"), \
                 }

#define PRAGMA_HLS_BIND_OP \
                 { \
                     reqVarRefExpr("variable"), \
                     reqId("op"), \
                     optId("impl"), \
                     optICEExpr("latency", -1), \
                 }

#define PRAGMA_HLS_BIND_STORAGE \
                 { \
                     reqVarRefExpr("variable"), \
                     reqId("type"), \
                     optId("impl"), \
                     optICEExpr("latency", -1), \
                 }

#define PRAGMA_HLS_CACHE \
                 { \
                     reqVarRefExpr("port"), \
                     optICEExpr("lines", 1), \
                     optICEExpr("depth", 0), \
                     optICEExpr("ways", 1), \
                     optICEExpr("users", 1), \
                     optEnum("burst", {"off", "on"}), \
                     optEnum("write_mode", {"write_back", "write_through"}), \
                 }

#define PRAGMA_HLS_AP_STABLE \
                 { \
                 }

#define PRAGMA_HLS_DATA_PACK \
                 { \
                     reqVarRefExpr("variable"), \
                     optId("instance"), \
                     presentId("struct_level", 1), \
                     presentId("field_level", 1), \
                     optEnum("byte_pad", {"struct_level", "field_level"}), \
                 }

#define PRAGMA_HLS_DATAFLOW \
                 { \
                     presentId("interval", 0), \
                     presentId("disable_start_propagation", 1), \
                 }

#define PRAGMA_HLS_DEPENDENCE \
                 { \
                     optVarRefExpr("cross_variables"), \
                     optVarRefExpr("variable"), \
                     presentId("array", 1), \
                     presentId("pointer", 1), \
                     presentId("intra", 2), \
                     presentId("inter", 2), \
                     presentId("raw", 3), \
                     presentId("war", 3), \
                     presentId("waw", 3), \
                     optICEExpr("distance"), \
                     presentId("true", 0), \
                     presentId("false", 0), \
                     optEnum("class", {"array", "pointer"}), \
                     optEnum("type", {"intra", "inter"}), \
                     optEnum("dependent", {"true", "false"}), \
                     optEnum("direction", {"raw", "war", "waw"}), \
                 }

#define PRAGMA_HLS_DISAGGREGATE \
                 { \
                     reqVarRefExpr("variable"), \
                 }

#define PRAGMA_HLS_EXPRESSION_BALANCE \
                 { \
                     presentId("off", 1), \
                 }

#define PRAGMA_HLS_FUNCTION_ALLOCATION \
                 { \
                     reqVarRefExpr("instances"), \
                 }

#define PRAGMA_HLS_FUNCTION_INSTANTIATE \
                 { \
                     reqVarRefExpr("variable"), \
                 }

#define PRAGMA_HLS_INLINE \
                 { \
                     presentId("self", 1), \
                     presentId("all", 1), \
                     presentId("region", 1), \
                     optEnum("type", {"self", "all", "region"}), \
                     presentId("recursive", 2), \
                     presentId("off", 3), \
                 }

#define PRAGMA_HLS_INTERFACE \
                 { \
                     reqVarRefExpr("port"), \
                     optId("name"), \
                     presentId("m_axi", 6), \
                     presentId("s_axilite", 6), \
                     presentId("axis", 6), \
                     presentId("ap_memory", 6), \
                     presentId("bram", 6), \
                     presentId("ap_none", 6), \
                     presentId("ap_fifo", 6), \
                     presentId("ap_hs", 6), \
                     presentId("ap_ack", 6), \
                     presentId("ap_vld", 6), \
                     presentId("ap_ovld", 6), \
                     presentId("ap_stable", 6), \
                     presentId("ap_bus", 6), \
                     presentId("ap_ctrl_none", 6), \
                     presentId("ap_ctrl_hs", 6), \
                     presentId("ap_ctrl_chain", 6), \
                     optEnum("mode", {"ap_none", "ap_vld", "ap_ack", "ap_hs", "ap_ovld", "ap_fifo", "ap_memory", "bram", "axis", "s_axilite", "m_axi", "ap_ctrl_none", "ap_ctrl_hs", "ap_ctrl_chain", "ap_stable"}), \
                     optId("bundle", "0"), \
                     optICEExpr("depth", 0), \
                     optICEExpr("num_read_outstanding", 16), \
                     optICEExpr("num_write_outstanding", 16), \
                     optICEExpr("max_read_burst_length", 16), \
                     optICEExpr("max_write_burst_length", 16), \
                     optICEExpr("latency", 0), \
                     optICEExpr("max_widen_bitwidth", 0), \
                     optICEExpr("channel"), \
                     presentId("register", 1), \
                     optEnum("register_mode", {"forward", "reverse", "off", "both"}), \
                     presentId("forward", 2), \
                     presentId("reverse", 2), \
                     presentId("both", 2), \
                     presentId("off", 2), \
                     optId("clock"), \
                     optId("storage_impl"), \
                     optId("storage_type", "default"), \
                     optICEExpr("interrupt", 0), \
                     optCallBackParser("offset", ParseoffsetOptionForinterface), \
                 }

#define PRAGMA_HLS_AP_STABLE \
                 { \
                     presentId("register", 1), \
                     optICEExpr("depth", 0), \
                     optICEExpr("latency", 0), \
                     optICEExpr("interrupt", 0), \
                 }

#define PRAGMA_HLS_LATENCY \
                 { \
                     optICEExpr("min", 0), \
                     optICEExpr("max", 65535), \
                 }

#define PRAGMA_HLS_LOOP_FLATTEN \
                 { \
                     presentId("off", 1), \
                 }

#define PRAGMA_HLS_LOOP_MERGE \
                 { \
                     presentId("force", 1), \
                 }

#define PRAGMA_HLS_LOOP_TRIPCOUNT \
                 { \
                     optICEExpr("min", 0), \
                     reqICEExpr("max"), \
                     optICEExpr("avg", 0), \
                 }

#define PRAGMA_HLS_MAXI_INTERFACE \
                 { \
                     optId("bundle", "0"), \
                     optICEExpr("depth", 0), \
                     optId("offset"), \
                     optICEExpr("num_read_outstanding", 16), \
                     optICEExpr("num_write_outstanding", 16), \
                     optICEExpr("max_read_burst_length", 16), \
                     optICEExpr("max_write_burst_length", 16), \
                     optICEExpr("latency", 0), \
                     optICEExpr("max_widen_bitwidth", 0), \
                     optICEExpr("channel"), \
                 }

#define PRAGMA_HLS_OCCURRENCE \
                 { \
                     optICEExpr("cycle", 1), \
                 }

#define PRAGMA_HLS_OPERATION_ALLOCATION \
                 { \
                     reqId("instances"), \
                 }

#define PRAGMA_HLS_PERFORMANCE \
                 { \
                     optDCEExpr("target_ti", 0.0), \
                     optDCEExpr("target_tl", 0.0), \
                     optDCEExpr("assume_ti", 0.0), \
                     optDCEExpr("assume_tl", 0.0), \
                     optEnum("scope", {"loop", "region"}), \
                 }

#define PRAGMA_HLS_PIPELINE \
                 { \
                     optICEExpr("ii", -1), \
                     presentId("rewind", 1), \
                     presentId("enable_flush", 2), \
                     presentId("off", 3), \
                     optEnum("style", {"stp", "flp", "frp"}), \
                 }

#define PRAGMA_HLS_PROTOCOL \
                 { \
                     presentId("floating", 1), \
                     presentId("fixed", 1), \
                     optEnum("mode", {"fixed", "floating"}), \
                 }

#define PRAGMA_HLS_REALPROBE \
                 { \
                     presentId("self", 1), \
                     presentId("all", 1), \
                     presentId("region", 1), \
                     optEnum("type", {"self", "all", "region"}), \
                     presentId("recursive", 2), \
                     presentId("off", 3), \
                 }

#define PRAGMA_HLS_RESET \
                 { \
                     reqVarRefExpr("variable"), \
                     presentId("off", 1), \
                 }

#define PRAGMA_HLS_RESOURCE \
                 { \
                     reqVarRefExpr("variable"), \
                     reqId("core"), \
                     optEnum("ecc_mode", {"none", "encode", "decode", "both"}), \
                     optICEExpr("latency", -1), \
                     presentId("auto", 1), \
                     presentId("distribute", 1), \
                     presentId("block", 1), \
                     presentId("uram", 1), \
                     optEnum("memory_style", {"auto", "distribute", "block", "uram"}), \
                     optId("metadata"), \
                 }

#define PRAGMA_HLS_S_AXILITE \
                 { \
                     optId("bundle", "0"), \
                     optICEExpr("offset", 0), \
                     optId("clock"), \
                     optId("storage_impl"), \
                 }

#define PRAGMA_HLS_AP_SCALAR \
                 { \
                     presentId("register", 1), \
                     optICEExpr("depth", 0), \
                     optICEExpr("latency", 0), \
                 }

#define PRAGMA_HLS_SHARED \
                 { \
                     reqVarRefExpr("variable"), \
                 }

#define PRAGMA_HLS_STABLE_CONTENT \
                 { \
                     reqVarRefExpr("variable"), \
                 }

#define PRAGMA_HLS_STABLE \
                 { \
                     reqVarRefExpr("variable"), \
                 }

#define PRAGMA_HLS_STREAM \
                 { \
                     reqVarRefExpr("variable"), \
                     optICEExpr("depth", 0), \
                     optICEExpr("dim", 0), \
                     presentId("off", 1), \
                     optEnum("type", {"fifo", "pipo", "shared", "unsync"}), \
                 }

#define PRAGMA_HLS_TOP \
                 { \
                     optId("name"), \
                 }

#define PRAGMA_HLS_UNROLL \
                 { \
                     optICEExpr("factor"), \
                     presentId("region", 1), \
                     presentId("complete", 1), \
                     presentId("partial", 1), \
                     optEnum("type", {"partial", "complete", "region"}), \
                     presentId("skip_exit_check", 2), \
                 }

