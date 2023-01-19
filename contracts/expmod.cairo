
%builtins output range_check

from starkware.cairo.common.uint256 import (
    Uint256, uint256_add, uint256_sub, uint256_mul, 
    uint256_unsigned_div_rem, uint256_eq, uint256_check
    )
// This function calculates a^b % p via recursive call to multiplication.
// Inspired by: https://www.geeksforgeeks.org/modular-exponentiation-recursive/
func uint256_expmod_recursive{output_ptr: felt*, range_check_ptr: felt}(a: Uint256, b: Uint256, p: Uint256) -> (res_low: felt, res_high: felt) {
    alloc_locals;
    // Base Cases
    // if (A == 0):
    //     return 0
    // if (B == 0):
    //     return 1
    let (istrue) = uint256_eq(a,Uint256(low=0,high=0));
    if (istrue == 1) {
        return (res_low=0, res_high = 0);
    }
    let (istrue) = uint256_eq(b,Uint256(low=0,high=0));
    if (istrue == 1) {
        return (res_low=1, res_high = 0);
    }
    // If B is Even
    // if (B % 2 == 0):
    //     y = exponentMod(A, B / 2, C)
    //     y = (y * y) % C
    //     return ((y + C) % C)
    let (quotient,remainder) = uint256_unsigned_div_rem(b,Uint256(low=2,high=0));
    let (istrue) = uint256_eq(remainder,Uint256(0,0));
    if (istrue == 1) {
        let (local z, local w) = uint256_expmod_recursive(a=a, b=quotient, p=p);
        let y = Uint256(low=z,high=w);
        let (y_square, carry) = uint256_mul(y, y);
        assert carry = Uint256(0, 0);
        let (y_res_quotient,y_res_remainder) = uint256_unsigned_div_rem(y_square, p);
        let final_resultat1 = y_res_remainder;
        let (addition,_) = uint256_add(final_resultat1, p);
        let (real1_final_result_quotient,real1_final_result_remainder) = uint256_unsigned_div_rem(addition, p);
        tempvar output_ptr = output_ptr;
        tempvar range_check_ptr = range_check_ptr;
    // uint256_check(real_final_result_remainder);
        return (res_low=real1_final_result_remainder.low, res_high = real1_final_result_remainder.high);
    } else {
    // If B is Odd
    // else:
    //     y = A % C
    //     y = (y * exponentMod(A, B - 1, C) % C) % C
    // return ((y + C) % C)
        let (y_res_quotient,y_res_remainder) = uint256_unsigned_div_rem(a,p);
        let (b_minus_1) = uint256_sub(b, Uint256(low=1,high=0));
        let (local z_recursive, local w_recursive) = uint256_expmod_recursive(a=a, b=b_minus_1, p=p);
        let recursive = Uint256(z_recursive,w_recursive);
        let (div_res_quotient,div_res_remainder) = uint256_unsigned_div_rem(recursive, p);
        let (res_mul, carry) = uint256_mul(y_res_remainder, div_res_remainder);
        assert carry = Uint256(0, 0);
        let (final_res_quotient,final_res_remainder) = uint256_unsigned_div_rem(res_mul, p);
        let (addition,_) = uint256_add(final_res_remainder, p);
        let (real1_final_result_quotient,real1_final_result_remainder) = uint256_unsigned_div_rem(addition, p);
        tempvar output_ptr = output_ptr;
        tempvar range_check_ptr = range_check_ptr;
        return (res_low=real1_final_result_remainder.low, res_high = real1_final_result_remainder.high);
}

}
    func print_uint256(val: Uint256) {
        %{
            low = memory[ids.val.address_]
            high = memory[ids.val.address_ + 1]
            print(f"Uint256(low={low}, high={high}) = {2 ** 128 * high + low}")
        %}
        return ();
    }

func main{output_ptr: felt*, range_check_ptr: felt}() {
    let (res_low, res_high) = uint256_expmod_recursive(a=Uint256(low=4592929292922929292,high=0),b=Uint256(low=3,high=0),p=Uint256(low=299999991,high=0)); 
    //returns 1
    let res = Uint256(low=res_low, high=res_high);
    // Output the result.
    print_uint256(res);
    return ();
}

// /*
// def exponentMod(A, B, C):
     
//     # Base Cases
//     if (A == 0):
//         return 0
//     if (B == 0):
//         return 1
     
//     # If B is Even
//     y = 0
//     if (B % 2 == 0):
//         y = exponentMod(A, B / 2, C)
//         y = (y * y) % C
     
//     # If B is Odd
//     else:
//         y = A % C
//         y = (y * exponentMod(A, B - 1,
//                              C) % C) % C
//     return ((y + C) % C)
 
// # Driver Code
// A = 2
// B = 5
// C = 13
// print("Power is", exponentMod(A, B, C))
// */
