local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local ramadanAccuRechargeltCtrl = include("ramadanAccuRechargeltCtrl")
local ramadanAccuRechargeCtrl = SoraDGetCtrl("ramadanAccuRechargeCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_accuMain = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RamadanAccuRecharge/Com_accuMain", Com_accuMain)
function Com_accuMain:onInit()
	self:fixChildrenPos()
	local classtype = activityShowCtrl:getParamByID(gActivityTimeActivityID.RAMADAN_ACCUMULATE_RECHARGE).classtype
	self.reachPointList = ramadanAccuRechargeltCtrl.getPointRewardDataByClassType(classtype)
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.totalHeight = self.fields.bar:getHeight()
end
function Com_accuMain:initData()
	dump(self.reachPointList, "Com_accuMain:initData")
	self.fields.scroll:setNumItems(table.nums(self.reachPointList))
	self.fields.scroll:resizeToFit(table.nums(self.reachPointList), 200)
	self:setProgress()
end
function Com_accuMain:refreshData()
	self.fields.scroll:setNumItems(table.nums(self.reachPointList))
	self.fields.scroll:resizeToFit(table.nums(self.reachPointList), 200)
	self:setProgress()
end
function Com_accuMain:setProgress()
	local curScore = ramadanAccuRechargeCtrl:getCurScore()
	if curScore == 0 then
		self.fields.bar:setFillAmount(0.99999)
		return
	end
	local step = 1.0 / table.nums(self.reachPointList)
	local curLevel = self:getCurScoreLevel(curScore)
	local percent = curLevel * (step * 1.08)
	if percent == 0 then
		self.fields.bar:setFillAmount(0.9999999)
		return
	elseif 1 < percent then
		percent = 0.99999
	end
	self.fields.bar:setFillAmount(1 - percent)
end
function Com_accuMain:getCurScoreLevel(curScore)
	local curlevel = 0
	for i, v in ipairs(self.reachPointList) do
		if curScore > v.point then
			curlevel = curlevel + 1
		else
			break
		end
	end
	return curlevel
end
function Com_accuMain:onItemRenderer(index, obj)
	dump(self.reachPointList[index + 1], "fjksdfskfld")
	obj:initData(index + 1, self.reachPointList[index + 1])
end
function Com_accuMain:onShow()
end
return Com_accuMain
