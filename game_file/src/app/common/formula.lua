local PF = include("prop_formula")
rawset(_G, "calcFormula", function(fid, ...)
	if not PF[fid] then
		return 0
	end
	local f = PF[fid].formula
	if type(f) == "function" then
		return f(...)
	else
		return f
	end
end)
function calcFormulaI(...)
	return math.floor(calcFormula(...))
end
