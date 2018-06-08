/*
Copyright 2013-present Barefoot Networks, Inc. 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// TODO: define headers & header instances
header_type easy_route_header{
    fields{
        preamble: 64;
        num_valid: 32;
    }
}

header_type easy_route_port{
    fields{
        port1: 8;
    }
}

header_type p2_type{
    fields{
        p2type: 8;
    }
}



header_type p2_key{
    fields{
        key: 32;
    }
}

header_type p2_value{
    fields{
        value: 32;
    }
}

header easy_route_header e_head;
header easy_route_port e_port;
header p2_type p2Type;
header p2_key p2Key;
header p2_value p2Value;





parser start {
    // TODO
    return select(current(0,64)){
        1: extract_head;
        default: ingress;
    }
}

// TODO: define parser states
parser extract_head{
    extract(e_head);
    return extract_port1;
}

parser extract_port1{
    extract(e_port);
    return extract_type;
}

parser extract_type{
    extract(p2Type);
    return extract_key;
}
parser extract_key{
    extract(p2Key);
    return extract_value;
}

parser extract_value{
    extract(p2Value);
    return ingress;
}
register store{
    width:32;
    
    instance_count:1000;
    
}
action _drop() {
    drop();
}

action get() {
    modify_field(standard_metadata.egress_spec, e_port.port1);
    register_read(p2Value.value,store,p2Key.key);
    add_to_field(p2Type.p2type,+2);
}
action put(){
    modify_field(standard_metadata.egress_spec, e_port.port1);
    register_write(store,p2Key.key,p2Value.value);
    add_to_field(p2Type.p2type,+2);
}

//action
control ingress {
    // TODO
    apply(ppp);
}

control egress {
    // leave empty
}





table ppp{
    reads{
        p2Type.p2type: exact;
    }
    actions{
        _drop;
        get;
        put;
    }
    
}
