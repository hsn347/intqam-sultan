local heroAppointCtrl = SoraDGetCtrl("heroAppointCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local cityltCtrl = include("cityltCtrl")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroAppointPopPanel = class("HeroAppointPopPanel", baseFguiPanel)
function HeroAppointPopPanel:ctor(...)
	HeroAppointPopPanel.super.ctor(self, ...)
	print("HeroAppointPopPanel:ctor", self.viewName)
end
function HeroAppointPopPanel:onInit()
	print("=======HeroAppointPopPanel:onInit")
	self.heroList, _ENV, self.selectHeroID = print, print, nil
	self.fields.Panel_bg:setString(i18n("hero_appoint_12"))
	self.fields.Text_attr:setString(i18n("hero_appoint_13"))
	self.fields.Text_BuildAttr:setString(i18n("hero_appoint_15"))
	self.fields.Lab_list:setString(i18n("hero_title_07"))
	self.fields.Btn_ok:setString(i18n("common_text_204"))
	self.fields.Btn_ok:addClickListener(handler(self, self.btnOkClick))
	self.fields.Btn_ok:setEnabled(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onHeroRenderer))
	self.fields.Text_attr:fixPos()
	self.fields.Lab_attr:fixPos()
	self.fields.Btn_heroPre:fixPos()
end
function HeroAppointPopPanel:onHeroRenderer(index, obj)
	obj:initData(self.heroList[index + 1], self.selectHeroID)
end
function HeroAppointPopPanel:onShow()
	print("=======HeroAppointPopPanel:onShow")
	self.bid = self.param.bid
	self.heroID = self.param.heroID
	self.cfg = cityltCtrl.getBuildHeroAppointCfg(self.bid)
	local myHeroList = heroCtrl:getHaveHerosList()
	self.heroList, _ENV = heroCtrl, heroCtrl
	for k, v in ipairs(myHeroList) do
		local heroID = tonumber(v)
		if next(heroltCtrl:getHeroAppointAttr(heroID)) and (self.heroID and self.heroID ~= heroID or not self.heroID) then
			local attrTb = heroltCtrl:getHeroAppointAttr(heroID)
			local appointBid = heroAppointCtrl:isHeroBeAppoint(heroID)
			_ENV = heroltCtrl:getHeroAppointAttr(heroID)
			heroltCtrl:getHeroAppointAttr(heroID).heroID = heroID
			heroltCtrl:getHeroAppointAttr(heroID).value = attrTb[self.cfg.direction]
			heroltCtrl:getHeroAppointAttr(heroID).isBeAppoint = appointBid and 1 or 0
			table.insert(self.heroList, heroltCtrl:getHeroAppointAttr(heroID))
		end
	end
	table.sort(self.heroList, function(a, b)
		if a.isBeAppoint == b.isBeAppoint then
			return a.value > b.value
		end
		return a.isBeAppoint < b.isBeAppoint
	end)
	self.fields.List:setNumItems(#self.heroList)
	self:initData(self.heroID)
end
function HeroAppointPopPanel:selectBack(target, data)
	self.selectHeroID = data.heroID
	self.fields.Btn_ok:setEnabled(self.selectHeroID ~= nil)
	self:initData(self.selectHeroID)
	self.fields.List:setNumItems(#self.heroList)
end
function HeroAppointPopPanel:initData(heroID)
	heroltCtrl = nil
	;(nil).heroID = heroID
	;(nil).isBeAppoint = 0
	self.fields.Btn_heroPre:initData(nil)
	if heroID then
		local attrTb = heroltCtrl:getHeroAppointAttr(heroID)
		local heroltCtrl, attrStrTb = heroltCtrl, heroltCtrl
		for k, v in ipairs(attrTb) do
			heroltCtrl = nil
			;(nil).des = cityltCtrl.getHeroAttrName(k)
			;(nil).num = v
			local attrStr = fguiHelper.getColorString(k == self.cfg.direction and "#70C723" or "#B4A078", i18n("%{des}:%{num}", nil))
			table.insert(attrStrTb, attrStr)
		end
		self.fields.Lab_attr:setString(table.concat(attrStrTb, "\n"))
		cityltCtrl = table.concat(attrStrTb, "\n")
		table.concat(attrStrTb, "\n")[1] = "buffType"
		table.concat(attrStrTb, "\n")[2] = "buffValue"
		local buildAttrTb = serviceFunctions.tableFormat(self.cfg.attribute, table.concat(attrStrTb, "\n"))
		local heroltCtrl, buildAttrStrTb = self.cfg.attribute, self.cfg.attribute
		for k, v in ipairs(buildAttrTb) do
			local value = v.buffValue * (1 + attrTb[self.cfg.direction] / 1000)
			local buffName = buffDesRead.getTitleWithValue(v.buffType)
			buffName = string.gsub(buffName, "<", "&lt;")
			local valStr = buffDesRead.getTitleValueWithValue(v.buffType, value)
			heroltCtrl = table.concat(attrStrTb, "\n")
			table.concat(attrStrTb, "\n").name = buffName
			table.concat(attrStrTb, "\n").num = fguiHelper.getColorString("#70C723", valStr)
			table.insert(buildAttrStrTb, i18n("%{name}:%{num}", table.concat(attrStrTb, "\n")))
		end
		self.fields.Lab_buildAttr:setString(table.concat(buildAttrStrTb, "\n"))
	else
		self.fields.Lab_attr:setString(i18n("hero_appoint_14"))
		self.fields.Lab_buildAttr:setString(i18n("hero_appoint_14"))
	end
end
function HeroAppointPopPanel:btnOkClick()
	SoraDPlaySound()
	local appointBid = heroAppointCtrl:isHeroBeAppoint(self.selectHeroID)
	if appointBid then
		_ENV = nil
		_ENV = nil
		;(nil).name = include("buildDescribeRead").getName(appointBid)
		;(nil).content = i18n("hero_appoint_37", nil)
		;(nil).confirmString = i18n("common_text_204")
		;(nil).cancelString = i18n("common_text_185")
		;(nil).confirmFunc = function()
			heroAppointCtrl:reqAppoint(self.bid, self.selectHeroID)
			self:close()
		end
		uiManager:show("MessageBox", nil)
		return
	end
	heroAppointCtrl:reqAppoint(self.bid, self.selectHeroID)
	self:close()
end
function HeroAppointPopPanel:onHide()
	_ENV = nil
	;(nil).byUID = true
	local isGuide = SoraDConfigGet("Game:HeroAppoint:appointGuide~bool", nil)
	if not isGuide then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:HeroAppoint:appointGuide~bool", true, nil)
	end
end
function HeroAppointPopPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "firstHero" then
		return self.fields.List:getChildAt(0)
	else
		return self.fields[itemName]
	end
end
return HeroAppointPopPanel
