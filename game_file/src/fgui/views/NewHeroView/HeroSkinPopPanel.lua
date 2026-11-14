local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroSkinPopPanel = class("HeroSkinPopPanel", baseFguiPanel)
function HeroSkinPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroSkinPopPanel:ctor", self.viewName)
end
function HeroSkinPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroSkinPopPanel:onInit()
	print("=======HeroSkinPopPanel:onInit")
	self.itemList, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("skin_text_15"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRederer))
	_ENV = handler(self, self.onItemRederer)
	_ENV, _ENV, handler(self, self.onItemRederer).defaultClick = handler(self, self.onItemRederer)
	_ENV, handler(self, self.onItemRederer)[1], handler(self, self.onItemRederer).title = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).tabsetArray, handler(self, self.onItemRederer)[2], handler(self, self.onItemRederer).title = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(handler(self, self.onItemRederer))
end
function HeroSkinPopPanel:onShow()
	print("=======HeroSkinPopPanel:onShow")
end
function HeroSkinPopPanel:onItemRederer(index, target)
	local v = self.itemList[index + 1]
	target:fixChildrenPos()
	local Text_attr = target:getChild("Text_attr")
	local Text_source = target:getChild("Text_source")
	Text_attr:setString(buffDesRead.getTitleWithValue(v.id, v.value))
	Text_attr:setColor(v.isActive and cc.c3b(255, 231, 187) or cc.c3b(126, 126, 126))
	if self.tag == 1 then
		Text_source:setString("")
		Text_attr:setColor(cc.c3b(255, 231, 187))
	else
		buffDesRead = cc.c3b(255, 231, 187)
		cc.c3b(255, 231, 187).var1 = i18n(heroltCtrl.getHeroName(v.heroID))
		cc.c3b(255, 231, 187).var2 = i18n(heroltCtrl:getDressName(v.dressID))
		Text_source:setString(i18n("(%{var1}:%{var2})", cc.c3b(255, 231, 187)))
		Text_source:setColor(v.isActive and cc.c3b(255, 231, 187) or cc.c3b(126, 126, 126))
	end
	target:getChildByName("Image_sheer"):setVisible(index % 2 == 1)
end
function HeroSkinPopPanel:onClickTab(tag)
	self.num = 0
	self.itemList, heroCtrl, self.tag = nil, nil, tag
	local heroCtrl, itemList
	if tag == 1 then
		itemList, self.num = heroCtrl:getAllActiveBuff()
		self.fields.Text_None:setString(i18n("heroDress_text_006"))
		if not next(self.itemList) then
			self.fields.Text_None:setString(i18n("skin_text_04"))
		end
	else
		itemList, self.num = heroCtrl:getAllOwnBuff()
		self.fields.Text_None:setString(i18n("skin_text_04"))
	end
	for k, v in ipairs(itemList) do
		if heroltCtrl.getHeroName(v.heroID) then
			table.insert(self.itemList, v)
		end
	end
	if self.num == 0 or not next(self.itemList) then
		self.fields.Text_None:setVisible(true)
		self.fields.list:setVisible(false)
	else
		self.fields.Text_None:setVisible(false)
		self.fields.list:setVisible(true)
		self.fields.list:setNumItems(#self.itemList)
	end
end
return HeroSkinPopPanel
