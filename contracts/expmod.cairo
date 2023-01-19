// The following code prints the sum of the numbers from 1 to 10.
// Modify the function `compute_sum` to print all the intermediate sums:
// 1, 1 + 2, 1 + 2 + 3, ..., 1 + 2 + ... + 10.
// Note: you'll have to add the implicit argument output_ptr to the
// declaration of compute_sum (in order to use the serialize_word function):
//   func compute_sum{output_ptr: felt*}(n: felt) -> (sum: felt)

// Use the output builtin.
%builtins output  range_check

// from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.uint256 import (
    Uint256, uint256_add, uint256_sub, uint256_mul, 
    uint256_unsigned_div_rem, uint256_eq, uint256_check
    )
// from starkware.cairo.common.bool import TRUE

func compute_sum{output_ptr: felt*, range_check_ptr: felt}(a: Uint256, b: Uint256, pf: Uint256) -> (res_low: felt, res_high: felt) {
        // Base cases
    alloc_locals;
    let (istrue) = uint256_eq(a,Uint256(low=0,high=0));
    if (istrue == 1) {
    return (res_low=0, res_high = 0);
    }
    let (istrue) = uint256_eq(b,Uint256(low=0,high=0));
    if (istrue == 1) {
    return (res_low=1, res_high = 0);
     }
    // If B is even
    // y = 0
    // if (B % 2 == 0):
    //     y = exponentMod(A, B / 2, C)
    //     y = (y * y) % C
     
    // let y2 = Uint256(low=0,high=0);
    let (quotient,remainder) = uint256_unsigned_div_rem(b,Uint256(low=2,high=0));
    let (istrue) = uint256_eq(remainder,Uint256(0,0));
    if (istrue == 1) {
        let (local z, local w) = compute_sum(a=a, b=quotient, pf=pf);
        let y = Uint256(low=z,high=w);
        let (res_mul, carry) = uint256_mul(y, y);
        assert carry = Uint256(0, 0);
        let y_square = res_mul;
        let (y_res_quotient,y_res_remainder) = uint256_unsigned_div_rem(y_square, pf);
        let final_resultat1 = y_res_remainder;




    let (addition,_) = uint256_add(final_resultat1, pf);
    let (real1_final_result_quotient,real1_final_result_remainder) = uint256_unsigned_div_rem(addition, pf);
            tempvar output_ptr = output_ptr;
        tempvar range_check_ptr = range_check_ptr;
    // uint256_check(real_final_result_remainder);
    return (res_low=final_resultat1.low, res_high = final_resultat1.high);



        // y = y_res_remainder;

        // y = y_res_remainder;
    //     let (low,high) = uint256_mul(y,y);
    //     let (quetient2,remainder2) = uint256_unsigned_div_rem(low, p);
    //     // y = remainder2;
    // } else {
    //     let (quetient3,remainder3) = uint256_unsigned_div_rem(a,Uint256(0,1), p);
    //     y = remainder3;
    //     let (quetient4,remainder4) = uint256_unsigned_div_rem(a,uint256_sub(b,Uint256(0,1)), p);
    //     local ovo = uint256_mul(y,remainder4);
    //     let (quetient5,remainder5) = uint256_unsigned_div_rem(ovo,Uint256(0,1), p);
    //     y = remainder5;
    } else {
//     else:
//         y = A % C
//         rekurz = exponentMod(A, B - 1, C)
//         ovaj1 = rekurz % C
//         ovaj = y * ovaj1
//         y = ovaj % C
        let (y_res_quotient,y_res_remainder) = uint256_unsigned_div_rem(a,pf);
        let (b_minus_1) = uint256_sub(b, Uint256(low=1,high=0));
        let (local z_recurs, local w_recurs) = compute_sum(a=a, b=b_minus_1, pf=pf);
        let recurs = Uint256(z_recurs,w_recurs);
        let (ovaj1_res_quotient,ovaj1_res_remainder) = uint256_unsigned_div_rem(recurs, pf);

        let (res_mul, carry) = uint256_mul(y_res_remainder, ovaj1_res_remainder);
        assert carry = Uint256(0, 0);
        let ovaj = res_mul;
        let (final_res_quotient,final_res_remainder) = uint256_unsigned_div_rem(ovaj, pf);
        let final_resultat2 = final_res_remainder;

    let (addition,_) = uint256_add(final_resultat2, pf);
    let (real1_final_result_quotient,real1_final_result_remainder) = uint256_unsigned_div_rem(addition, pf);
            tempvar output_ptr = output_ptr;
        tempvar range_check_ptr = range_check_ptr;
    // uint256_check(real_final_result_remainder);
    return (res_low=final_resultat2.low, res_high = final_resultat2.high);
}
    //  let (quetient6:Uint256,remainder6:Uint256) = uint256_unsigned_div_rem(uint256_add(y,p),Uint256(0,1), p);
//     return ((y + C) % C)

 //    local (sum) = remainder6;

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
    let (res_low, res_high) = compute_sum(a=Uint256(low=45,high=0),b=Uint256(low=9,high=0),pf=Uint256(low=29,high=0)); 
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
