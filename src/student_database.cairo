%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address, get_block_timestamp

struct Student {
    name: felt,
    age: felt,
}

@storage_var
func students(address: felt) -> (data: Student) {
}

@storage_var
func owner() -> (address: felt) {
}

@event
func student_added(timestamp: felt, student: Student){
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(){
    let caller: felt = get_caller_address();
    owner.write(caller);
    return ();
}

@external
func add_student_record{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(student_address: felt, name: felt, age: felt) {
    let caller: felt = get_caller_address();
    let owner_address: felt = owner.read();
    assert caller = owner_address;
    let student = Student(name, age);
    students.write(student_address, student);
    let block_timestamp: felt = get_block_timestamp();
    student_added.emit(block_timestamp, student);
    return ();
}

@view
func get_student{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(student_address: felt) -> (student: Student){
    let student: Student = students.read(student_address);
    return (student,);
}