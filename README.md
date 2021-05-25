# Seme4CPU
大二下计算机组成原理课程大作业——CPU设计  
基于MIPS32指令集  
__目前仅有31条单周期CPU__
## 31条单周期CPU
Internal Code : __Lithium__

为匹配mips246网站进行的改动：  
RegFile与DRAM在上升沿写入。  
事实上相当于PC、RegFile、DRAM在下一个周期的上升沿写入，并且保证在本周期结束前将执行结果送至相应存储器的输入端口。  
理论上可以提升主频。