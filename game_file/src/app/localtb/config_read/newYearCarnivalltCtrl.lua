local newYearCarnivalltCtrl = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "new_year_carnival"
;(nil)[2] = true
newYearCarnivalltCtrl:defineValue("info", nil)
function newYearCarnivalltCtrl.getItemID()
	if newYearCarnivalltCtrl.info and table.nums(newYearCarnivalltCtrl.info) > 0 then
		return newYearCarnivalltCtrl.info[1].decorate
	end
	return nil
end
function newYearCarnivalltCtrl.getReward()
	if newYearCarnivalltCtrl.info and table.nums(newYearCarnivalltCtrl.info) > 0 then
		return newYearCarnivalltCtrl.info[1].reward
	end
	return nil
end
return newYearCarnivalltCtrl
