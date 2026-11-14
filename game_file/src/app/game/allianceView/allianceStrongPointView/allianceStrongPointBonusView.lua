local gametop = gModuleMgr.getObject("gametop")
local allianceStrontholdCtrl = gametop.playertop_:getModule("allianceStrontholdCtrl")
local buffDesRead = include("buffDesRead")
local allianceStrongPointBonusView = class("allianceStrongPointBonusView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceStrongPointBonusView")
	end
	return target
end)
function allianceStrongPointBonusView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("alliance_stronghold_text_031"))
	self.Text_none = SoraDGetChildByName(self, "Text_none")
	self.Text_none:setString(i18n("alliance_stronghold_text_103"))
	self.Node_info = SoraDGetChildByName(self, "Node_info")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("alliance_stronghold_text_104"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.Node_data = SoraDGetChildByName(self, "Node_data")
	self:initData()
end
function allianceStrongPointBonusView:initData()
	local bonusData = allianceStrontholdCtrl:getStrongholdBuff()
	local allianceStrontholdCtrl, showData = allianceStrontholdCtrl, allianceStrontholdCtrl
	for k, v in pairs(bonusData) do
		allianceStrontholdCtrl = nil
		;(nil).buff = k
		;(nil).val = v
		table.insert(showData, nil)
	end
	table.sort(showData, function(a, b)
		return a.buff < b.buff
	end)
	if next(showData) then
		self.Text_none:setVisible(false)
		self.Node_info:setVisible(true)
		local newH = math.max(self.scroll:getContentSize().height, 48 * #showData)
		self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, newH))
		for k, v in ipairs(showData) do
			local line
			if k == 1 then
				line = self.Node_data
			else
				line = self.Node_data:clone()
				line:addTo(self.scroll)
			end
			local Text_des = SoraDGetChildByName(line, "Text_des")
			local Text_val = SoraDGetChildByName(line, "Text_val")
			local Image_pbg = SoraDGetChildByName(line, "Image_pbg")
			Image_pbg:setVisible(k % 2 == 1)
			Text_des:setString(buffDesRead.getTitleBase(v.buff))
			local val = buffDesRead.getTitleValueWithValue(v.buff, v.val)
			if v.buff == gBuffEffect.INSTANT_BUILD_SPEED_BOOST then
				val = val .. "s"
			else
			end
			Text_val:setString(val)
			line:setPosition(self.scroll:getContentSize().width / 2, newH - k * 48)
		end
	else
		self.Text_none:setVisible(true)
		self.Node_info:setVisible(false)
	end
end
return allianceStrongPointBonusView
