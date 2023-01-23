// Computes x * y % p for Uint256 numbers via fast modular exponentiation algorithm.
// Time complexity is log_2(y).
// Loop is implemented via uint256_expmod_recursive_call() function.
func uint256_expmod{range_check_ptr: felt}(x: Uint256, y: Uint256, p: Uint256) -> (remainder: Uint256) {
    alloc_locals;
    let res = Uint256(low=1,high=0);
    let (x_low,x_high,y_low,y_high,res_low,res_high) = uint256_expmod_recursive_call(x,y,res,p);
    let (quotient,remainder) = uint256_unsigned_div_rem(Uint256(low=res_low,high=res_high),p);
    return (remainder=remainder);
}

func uint256_expmod_recursive_call{range_check_ptr: felt}(x: Uint256, y: Uint256, res: Uint256, p: Uint256) -> (r_x_low: felt, r_x_high: felt, r_y_low: felt, r_y_high: felt, r_res_low: felt, r_res_high: felt) {
    alloc_locals;
    let (is_greater_than_zero) = uint256_lt(Uint256(low=0, high=0),y);
    if ((is_greater_than_zero) == 1) {
        let (quotient, remainder) = uint256_unsigned_div_rem(y,Uint256(low=2, high=0));
        let (is_equal_to_one) = uint256_eq(remainder,Uint256(low=1, high=0));
        if ((is_equal_to_one) == 1) {
            let (x_res_res_quotient, x_res_res_quotient_high, x_res_res_remainder) = uint256_mul_div_mod(res,x,p);
            let (x_res_quotient,  x_res_quotient_high,  x_res_remainder) = uint256_mul_div_mod(x,x,p);
            let (x_low, x_high, y_low, y_high, res_low, res_high) = uint256_expmod_recursive_call(x=x_res_remainder,y=quotient,res=x_res_res_remainder,p=p);
            tempvar range_check_ptr = range_check_ptr;
            return (r_x_low=x_low,r_x_high=x_high,r_y_low=y_low,r_y_high=y_high,r_res_low=res_low,r_res_high=res_high);
        } else {
            let (x_res_quotient,  x_res_quotient_high,  x_res_remainder) = uint256_mul_div_mod(x,x,p);
            let (x_low, x_high, y_low, y_high, res_low, res_high) = uint256_expmod_recursive_call(x=x_res_remainder,y=quotient,res=res,p=p);
            tempvar range_check_ptr = range_check_ptr;
            return (r_x_low=x_low,r_x_high=x_high,r_y_low=y_low,r_y_high=y_high,r_res_low=res_low,r_res_high=res_high);
        }
    }
    return (r_x_low=x.low,r_x_high=x.high,r_y_low=y.low,r_y_high=y.high,r_res_low=res.low,r_res_high=res.high);
}
