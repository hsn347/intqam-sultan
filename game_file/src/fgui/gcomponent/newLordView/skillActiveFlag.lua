local equipDesRead = include("equipDesRead")
local artifactRuneRead = include("artifactRuneRead")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local godArmsCtrl = SoraDGetCtrl("godArmsCtrl")
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local skillActiveFlag = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://newLordView/skillActiveFlag", skillActiveFlag)
function skillActiveFlag:onInit()
	self.showRuneList, _ENV, self.isOpen = nil, nil, false
	self.fields.List_rune:setItemRenderer(handler(self, self.onRuneRenderer))
	self:addClickListener(handler(self, self.btnClick))
	self.fields.Button_attr:addClickListener(handler(self, self.btnAttrClick))
end
function skillActiveFlag:onShow()
end
function skillActiveFlag:onRuneRenderer(index, obj)
	obj:setIcon(artifactRuneRead.getRuneIcon(self.showRuneList[index + 1].rid))
end
function skillActiveFlag:initData(data)
	self.data = data
	self.fields.Image_arm:setSpriteFrame(equipDesRead.getArtifactIcon(self.data.weaponID))
	local isUnLock = godArmsCtrl:isWeaponUnlock(self.data.weaponID)
	self.controllers.c_lock:setSelectedIndex(isUnLock and 1 or 0)
	self.fields.Text_name:setString(i18n(self.data.name))
	self.fields.Node_skill:setIcon(self.data.icon)
	self.fields.Node_skill:getController("c_active"):setSelectedIndex(self.data.isActive and 1 or 0)
	local ret = godArmsRuneCtrl:isArmShowRune(self.data)
	self.fields.Button_attr:setVisible(ret)
	self.fields.List_rune:setVisible(ret)
	self.fields.Text_group:setVisible(ret)
	if ret then
		local showName = godArmsRuneCtrl:getUsingGroupName(self.data.weaponID)
		local group = godArmsRuneCtrl:getArmUsingGroup(self.data.weaponID)
		if showName == "" then
			showName = godArmsRuneCtrl:getArmGroupName(self.data.weaponID, group)
		end
		self.fields.Text_group:setString(showName)
		local setList = godArmsRuneCtrl:getArmDetailList(self.data.weaponID, 1)
		self.showRuneList, equipDesRead = godArmsRuneCtrl, godArmsRuneCtrl
		for k, v in pairs(setList) do
			local runeData = godArmsRuneCtrl:getRuneInfo(v)
			if tonumber(k) and v ~= 0 and runeData then
				equipDesRead = i18n(self.data.name)
				i18n(self.data.name).rid = runeData.rid
				i18n(self.data.name).hole = tonumber(k)
				table.insert(self.showRuneList, i18n(self.data.name))
			end
		end
		table.sort(self.showRuneList, function(a, b)
			return a.hole < b.hole
		end)
		self.fields.List_rune:setNumItems(#self.showRuneList)
	end
end
function skillActiveFlag:btnAttrClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.data
	uiManager:show("RuneAttrTotal", nil)
end
function skillActiveFlag:btnClick()
end
return skillActiveFlag
