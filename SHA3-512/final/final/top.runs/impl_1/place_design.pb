
Q
Command: %s
53*	vivadotcl2 
place_design2default:defaultZ4-113h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
	xc7vx485t2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
	xc7vx485t2default:defaultZ17-349h px� 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px� 
V
DRC finished with %s
79*	vivadotcl2
0 Errors2default:defaultZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
p
,Running DRC as a precondition to command %s
22*	vivadotcl2 
place_design2default:defaultZ4-22h px� 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px� 
V
DRC finished with %s
79*	vivadotcl2
0 Errors2default:defaultZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
U

Starting %s Task
103*constraints2
Placer2default:defaultZ18-103h px� 
}
BMultithreading enabled for place_design using a maximum of %s CPUs12*	placeflow2
22default:defaultZ30-611h px� 
v

Phase %s%s
101*constraints2
1 2default:default2)
Placer Initialization2default:defaultZ18-101h px� 
�

Phase %s%s
101*constraints2
1.1 2default:default29
%Placer Initialization Netlist Sorting2default:defaultZ18-101h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0052default:default2
1493.1722default:default2
0.0002default:defaultZ17-268h px� 
[
FPhase 1.1 Placer Initialization Netlist Sorting | Checksum: 10dda929b
*commonh px� 
�

%s
*constraints2s
_Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.022 . Memory (MB): peak = 1493.172 ; gain = 0.0002default:defaulth px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0042default:default2
1493.1722default:default2
0.0002default:defaultZ17-268h px� 
�

Phase %s%s
101*constraints2
1.2 2default:default2F
2IO Placement/ Clock Placement/ Build Placer Device2default:defaultZ18-101h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
�	
9Poor placement for routing between an IO pin and BUFG. %s528*place2�
�If this sub optimal condition is acceptable for this design, you may use the CLOCK_DEDICATED_ROUTE constraint in the .xdc file to demote this message to a WARNING. However, the use of this override is highly discouraged. These examples can be used directly in the .xdc file to override this clock rule.
	< set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_IBUF] >

	<MSGMETA::BEGIN::BLOCK>clk_IBUF_inst<MSGMETA::END> (IBUF.O) is locked to IPAD_X2Y162
	<MSGMETA::BEGIN::BLOCK>clk_IBUF_BUFG_inst<MSGMETA::END> (BUFG.I) is provisionally placed by clockplacer on BUFGCTRL_X0Y31
"�
clk_IBUF_inst2�If this sub optimal condition is acceptable for this design, you may use the CLOCK_DEDICATED_ROUTE constraint in the .xdc file to demote this message to a WARNING. However, the use of this override is highly discouraged. These examples can be used directly in the .xdc file to override this clock rule.
	< set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_IBUF] >

	:$ (IBUF.O) is locked to IPAD_X2Y162
	"[
clk_IBUF_BUFG_inst:C (BUFG.I) is provisionally placed by clockplacer on BUFGCTRL_X0Y31
2default:default8Z30-574h px� 
g
RPhase 1.2 IO Placement/ Clock Placement/ Build Placer Device | Checksum: 5e2f87fb
*commonh px� 
�

%s
*constraints2p
\Time (s): cpu = 00:00:11 ; elapsed = 00:00:08 . Memory (MB): peak = 1523.836 ; gain = 30.6642default:defaulth px� 
H
3Phase 1 Placer Initialization | Checksum: 5e2f87fb
*commonh px� 
�

%s
*constraints2p
\Time (s): cpu = 00:00:11 ; elapsed = 00:00:08 . Memory (MB): peak = 1523.836 ; gain = 30.6642default:defaulth px� 
�
�Placer failed with error: '%s'
Please review all ERROR and WARNING messages during placement to understand the cause for failure.
1*	placeflow2*
IO Clock Placer failed2default:defaultZ30-99h px� 
=
(Ending Placer Task | Checksum: 5e2f87fb
*commonh px� 
�

%s
*constraints2p
\Time (s): cpu = 00:00:11 ; elapsed = 00:00:08 . Memory (MB): peak = 1523.836 ; gain = 30.6642default:defaulth px� 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
412default:default2
02default:default2
32default:default2
32default:defaultZ4-41h px� 
N

%s failed
30*	vivadotcl2 
place_design2default:defaultZ4-43h px� 
m
Command failed: %s
69*common28
$Placer could not place all instances2default:defaultZ17-69h px� 
�
Exiting %s at %s...
206*common2
Vivado2default:default2,
Fri Oct 25 22:32:49 20242default:defaultZ17-206h px� 


End Record