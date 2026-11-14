local baseComponent = require("fgui.base.baseComponent")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local buffDesRead = include("buffDesRead")
local Com_MC_baseInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MythicalCreatures/Com_MC_baseInfo", Com_MC_baseInfo)
function Com_MC_baseInfo:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_MC_baseInfo:onShow()
end
function Com_MC_baseInfo:initData(divineID)
	local attBuffData = divineBeastCtrl:getAttBuffData(divineID)
	self:setVisible(next(attBuffData) ~= nil)
	local divineBeastCtrl, addValues = self.setVisible, self.setVisible
	for i = 1, 3 do
		if attBuffData[i] then
			self.fields["Text_val" .. i]:setString(buffDesRead.getTitleBase(attBuffData[i].buffType, false, true))
			self.fields["Text_add" .. i]:setString(buffDesRead.getTitleValueWithValue(attBuffData[i].buffType, SoraDPreciseDecimal(attBuffData[i].value, 2), false))
			addValues[i] = attBuffData[i].value
		end
	end
	if self.oldAddValues ~= nil and self.oldAddValues[divineID] ~= nil then
		for i, v in ipairs(self.oldAddValues[divineID]) do
			local newValue = addValues[i] or 0
			local oldAddValues = self.oldAddValues[divineID][i] or 0
			if newValue > oldAddValues then
				self.fields["Text_changeNum" .. i]:stopAllActions()
				self.fields["Text_changeNum" .. i]:setAlpha(0)
				self.fields["Text_changeNum" .. i]:setString(buffDesRead.getTitleValueWithValue(attBuffData[i].buffType, SoraDPreciseDecimal(newValue - oldAddValues, 2), false))
				self.fields["Text_changeNum" .. i]:setVisible(true)
				_UPVALUE3_ = self.fields["Text_changeNum" .. i].setVisible
				self.fields["Text_changeNum" .. i].setVisible[1] = ffa.fadeIn(0.1)
				self.fields["Text_changeNum" .. i].setVisible[2] = ffa.delay(0.5)
				self.fields["Text_changeNum" .. i].setVisible[3] = ffa.fadeOut(0.1)
				self.fields["Text_changeNum" .. i].setVisible[4] = ffa.callFunc(function()
					self.fields["Text_changeNum" .. i]:setVisible(false)
				end)
				self.fields["Text_changeNum" .. i].setVisible[5] = ffa.callFunc(function()
					self.fields["Text_changeNum" .. i]:setVisible(false)
				end)
				local self.fields["Text_changeNum" .. i].setVisible[6], seq = ffa.callFunc(function()
					self.fields["Text_changeNum" .. i]:setVisible(false)
				end)
				self.fields["Text_changeNum" .. i]:runAction(ffa.seq(seq))
				self.fields["effect" .. i]:setVisible(true)
				self.fields["effect" .. i]:setAllFrameNameOnce("dh_SSbj_%02d.png", 1, false)
			end
		end
	end
	if not self.oldAddValues then
		divineBeastCtrl = self.oldAddValues
	end
	self.oldAddValues = self.oldAddValues
	self.oldAddValues[divineID] = addValues
end
return Com_MC_baseInfo
