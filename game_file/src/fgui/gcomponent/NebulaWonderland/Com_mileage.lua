local nebulaWonderlandRead = include("nebulaWonderlandRead")
local nebulaWonderlandCtrl = SoraDGetCtrl("nebulaWonderlandCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_mileage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaWonderland/Com_mileage", Com_mileage)
function Com_mileage:onInit()
	self.brightData, nebulaWonderlandCtrl, self.preProgress = nil, nil, 0
	self.curMile = nebulaWonderlandCtrl:getProgress()
	self.rewardCfg = nebulaWonderlandRead.getRewardConfig()
	self.index = self:calCurIndex()
	for i = 1, 12 do
		self.fields["a" .. i]:setAllFrameName("dh_xingjingqy_ty%02d.png", 1)
	end
	for i = 1, 3 do
		self.fields["ad" .. i]:setAllFrameName("dh_xingyunqijing_ex%02d.png", 1)
	end
end
function Com_mileage:calCurIndex()
	local index = 1
	local left = 0
	for i, v in ipairs(self.rewardCfg) do
		if self.curMile >= v.integral then
			index = index + 1
			if 1 < i and i <= table.nums(self.rewardCfg) then
				self.fields["nl" .. i]:setStaticEffect(1)
			end
			self.fields["g" .. i]:setVisible(true)
		end
	end
	if 1 < index and index <= table.nums(self.rewardCfg) then
		left = self.curMile - self.rewardCfg[index - 1].integral
		self.fields["nl" .. index]:setStaticEffect(left / (self.rewardCfg[index].integral - self.rewardCfg[index - 1].integral))
	end
	return index
end
function Com_mileage:initData()
	for i = 1, 15 do
		if self.rewardCfg[i] then
			self.fields["n" .. i]:initData(i, self.rewardCfg[i].integral)
		end
	end
	if nebulaWonderlandCtrl:getProgress() > self.preProgress then
		self:showMileForwardAction()
		self.preProgress = nebulaWonderlandCtrl:getProgress()
	end
end
function Com_mileage:showMileForwardAction()
	self.callBackFunc(self.index)
	self.curMile = nebulaWonderlandCtrl:getProgress()
	nebulaWonderlandCtrl = nebulaWonderlandCtrl
	nebulaWonderlandCtrl[1] = ffa.callFunc(function()
		self:recursiveAction(self.index)
	end)
	nebulaWonderlandCtrl[2] = ffa.callFunc(function()
		self:recursiveAction(self.index)
	end)
	local seq = ffa.seq(nebulaWonderlandCtrl)
	self:runAction(seq)
end
function Com_mileage:setCallback(backHanle)
	self.callBackFunc = backHanle
end
function Com_mileage:setGiftState(index)
	self.fields["n" .. index]:setDynamicEffect(index)
end
function Com_mileage:recursiveAction(index)
	if index - 1 > 0 and not self.brightData[index] then
		if 6 <= index then
			self.callBackFunc(index)
		elseif 11 <= index then
			self.callBackFunc(index)
		end
		self.fields["g" .. index - 1]:setAlpha(0)
		self.fields["g" .. index - 1]:setVisible(true)
		self.fields["g" .. index - 1]:runAction(ffa.fadeIn(0.4))
		self.fields["n" .. index - 1]:setDynamicEffect(index - 1)
		self.brightData[index] = true
	end
	if index > table.nums(self.rewardCfg) then
		return
	end
	if index == 1 then
		if self.curMile < self.rewardCfg[1].integral then
			return
		end
		self.fields.g1:setVisible(true)
		self.fields.n1:setDynamicEffect(1)
		index = index + 1
	end
	if index >= self.index and self.curMile >= self.rewardCfg[index].integral then
		self.fields["nl" .. index]:setCallBack(handler(self, self.recursiveAction))
		self.fields["nl" .. index]:setDynamicEffect(index, 1)
	elseif index >= self.index then
		self.index = index
		local left = self.curMile - self.rewardCfg[index - 1].integral
		if 0 < left then
			self.fields["nl" .. index]:setDynamicEffect(index, left / (self.rewardCfg[index].integral - self.rewardCfg[index - 1].integral))
		end
	end
	return
end
function Com_mileage:onShow()
end
return Com_mileage
