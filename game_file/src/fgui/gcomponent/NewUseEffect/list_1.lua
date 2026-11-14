local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local list_1 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewUseEffect/list_1", list_1)
function list_1:onInit()
	self:fixChildrenPos()
	self.fields.Check_tick:addClickListener(handler(self, self.onTickClick))
end
function list_1:onShow()
end
function list_1:initData(data, showCheck, isCheckHero)
	dump(data, "data")
	self.itemID = data.id
	self.count = data.count
	self.fields.Com_Item:initData(data.id, data.count)
	local des = publicRead.getName(data.id)
	self.fields.Text_Num:setString(string.formatnumberthousands(data.count))
	if showCheck then
		self.controllers.c1:setSelectedIndex(1)
	end
	if isCheckHero then
		local heroltCtrl = include("heroltCtrl")
		local heroCtrl = SoraDGetCtrl("heroCtrl")
		local heroID = heroltCtrl:getHeroIdByHeroCard(data.id)
		if heroID ~= nil and heroCtrl:getHeroInfoByID(heroID) == nil then
			_ENV = "hero_title_08"
			;("hero_title_08").color = "#E02B2B"
			des = string.format("%s-%s", des, SoraDWrapHtmlTagByStyle(i18n("hero_title_08"), "hero_title_08"))
		end
	end
	self.fields.Text_Des:setString(des)
	self:checkHeroResource(data.noHero)
end
function list_1:showbg(ishow)
	self.fields.n10:setVisible(ishow)
end
function list_1:setCheckCallBack(handle)
	self.handle = handle
end
function list_1:onTickClick()
	SoraDPlaySound()
	local isSelected = self.fields.Check_tick:isSelected()
	if isSelected and self.handle then
		self:setCheck(true)
		self.handle(self)
	end
end
function list_1:enterAutoSelected()
	self:setCheck(true)
	self.handle(self)
end
function list_1:setCheck(isCheck)
	self.fields.Check_tick:setSelected(isCheck)
	self.fields.Check_tick:setTouchEnabled(not isCheck)
end
function list_1:checkHeroResource(noHero)
	if noHero then
		self.controllers.c2:setSelectedIndex(1)
		self.fields.Text_Waring:setString(i18n("common_text_2274"))
	end
end
return list_1
