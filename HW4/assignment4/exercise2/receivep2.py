#!/usr/bin/python

# Copyright 2013-present Barefoot Networks, Inc. 
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from scapy.all import sniff, sendp
from scapy.all import Packet
from scapy.all import ShortField, IntField, LongField, BitField

import sys
import struct

def handle_pkt(pkt):
    
    pkt = str(pkt)
    
    if len(pkt) < 12: return
    preamble = pkt[:8]
    preamble_exp = "\x00" * 7+"\x01"
    if preamble != preamble_exp: 
        return
    
    
    type=pkt[13]
    
    if type=='\x02':
        upvalue=pkt[18:]
        
        value=""
        for s in upvalue:
            value+=str(ord(s))
        i=0
        for i in range(len(value)):
            if value[i]!='0':
                break
        value=value[i:]
        
        print "type: ",ord(type)
        print "value: ",value
    elif type=='\x03':
        upindex=pkt[14:18]
        upvalue=pkt[18:]
        print "type: ",ord(type)
        index=""
        for s in upindex:
            index+=str(ord(s))
        i=0
        for i in range(len(index)):
            if index[i]!='0':
                break
        index=index[i:]
        value=""
        for s in upvalue:
            value+=str(ord(s))
        i=0
        for i in range(len(value)):
            if value[i]!='0':
                break
        value=value[i:]
        print "update key: ",index
        print "update value: ",value
    else:
        return
    sys.stdout.flush()

def main():
    sniff(iface = "eth0",
          prn = lambda x: handle_pkt(x))

if __name__ == '__main__':
    main()
