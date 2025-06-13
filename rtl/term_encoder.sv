// Created by ihdl
module term_encoder(thermometer_i, binary_o,enable_i);
input logic [6:0] thermometer_i;
output logic [2:0] binary_o;
input logic enable_i;

logic [2:0] binary_inside;
integer k, m;

always @ (posedge enable_i)
if (enable_i)
begin
	binary_inside = 0;
	for(k = 1; k <= 7; k = k + 1)
		if(thermometer_i[k-1] == 1'b1)
		binary_inside = k;
end else begin

binary_inside = k;
end

assign binary_o = binary_inside;

endmodule
