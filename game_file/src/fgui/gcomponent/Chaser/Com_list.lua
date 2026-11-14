local baseComponent = require("fgui.base.baseComponent")
local artifactRuneRead = include("artifactRuneRead")
local buffDesRead = include("buffDesRead")
local Com_list = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Chaser/Com_list", Com_list)
function Com_list:onInit()
	self.isChoose = false
	self.fields.n28:setVisible(self.isChoose)
	self.fields.Text_max:setString(i18n("common_text_283"))
	self:addClickListener(handler(self, self.onClick))
	self:fixChildrenPos()
	self.fields.n32:setScaleX(SoraDFIsRA() and 0.55 or -0.55)
	self.fields.MV_fly:setAllFrameName("dh_baoshi_add_%.2d.png", 1)
	self.fields.MV_fly:setVisible(false)
	self.fields.MV_fly:setScaleX(SoraDFIsRA() and -1.5 or 1.5)
end
function Com_list:onShow()
end
function Com_list:playFly()
	self.fields.MV_fly:setVisible(true)
	self.fields.MV_fly:setPlaySettings(0, -1, 1)
end
function Com_list:initData(data, index, rid, maxRandomLv, nextLvAdd)
	local isDiffrent = self.data and data[2] ~= self.data[2] or false
	self.data = data
	self.index = index
	local nextLvAdd = nextLvAdd[index] or 1
	local des, color, growType = self:getDesAndColor(data[1], data[2], data[3])
	self.growType = growType
	if not data[3] then
		if rid and index then
			local needClass = artifactRuneRead.getPropertyActivationClass(rid, index)
			artifactRuneRead = nil
			;(nil).num = needClass
			des = des .. i18n("Weapon_Rune_tips_056", nil)
		else
			des = des .. i18n("Weapon_Rune_tips_056")
		end
	end
	artifactRuneRead = nil
	;(nil).lv = data[2]
	self.fields.Text_curLv:setString(i18n("common_text_101", nil))
	self.fields.Text_cur:setString(des)
	self.fields.Text_curLv:setColor(color)
	self.fields.Text_cur:setColor(color)
	self.fields.spot_cur:setColor(color)
	self.maxLv = maxRandomLv
	if self.data[2] >= self.maxLv then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
		local nextLv = math.min(self.maxLv, data[2] + nextLvAdd)
		local desEx, colorEx = self:getDesAndColor(data[1], nextLv, data[3])
		if not data[3] then
			if rid and index then
				local needClass = artifactRuneRead.getPropertyActivationClass(rid, index)
				artifactRuneRead = i18n("common_text_101", nil)
				i18n("common_text_101", nil).num = needClass
				desEx = desEx .. i18n("Weapon_Rune_tips_056", i18n("common_text_101", nil))
			else
				desEx = desEx .. i18n("Weapon_Rune_tips_056")
			end
		end
		artifactRuneRead = i18n("common_text_101", nil)
		i18n("common_text_101", nil).lv = nextLv
		self.fields.Text_nextLv:setString(i18n("common_text_101", i18n("common_text_101", nil)))
		self.fields.Text_next:setString(desEx)
		self.fields.Text_nextLv:setColor(colorEx)
		self.fields.Text_next:setColor(colorEx)
		self.fields.spot_next:setColor(colorEx)
	end
	if isDiffrent then
		self:playFly()
	end
end
function Com_list:getDesAndColor(id, lv, isActive)
	local propertyArray, quality = artifactRuneRead.getPropertyArray(id)
	local des = ""
	local growType
	for k, v in ipairs(propertyArray) do
		local pLvCfg = artifactRuneRead.getPropertiesLvCfg(v.growType, lv)
		if k == #propertyArray then
			des = des .. buffDesRead.getBuffDes(v.buffType, v.buffVal + pLvCfg.GrowingValue, v.buffMode)
		else
			des = des .. buffDesRead.getBuffDes(v.buffType, v.buffVal + pLvCfg.GrowingValue, v.buffMode) .. ","
		end
		growType = v.growType
	end
	local color = artifactRuneRead.getColor(quality, isActive)
	return des, color, growType
end
function Com_list:onClick()
	SoraDPlaySound()
	if self.data[2] < self.maxLv then
		self.isChoose = not self.isChoose
		self.fields.n28:setVisible(self.isChoose)
		_ENV = self.fields.n28
		self.fields.n28.msg = "MESSAGE_UI_RUNE_STRENGTHEN_RANDOM"
		self.fields.n28.index = self.index
		self.fields.n28.isChoose = self.isChoose
		SoraDSendMessage(self.fields.n28)
	end
end
return Com_list
