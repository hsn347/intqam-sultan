local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_info = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_info", Com_info)
function Com_info:onInit()
	self.fields.Btn_help:addClickListener(handler(self, self.btnHelpClick))
	self.fields.btn_l:addTouchEventListener(handler(self, self.btnLeftPageClick))
	self.fields.btn_r:addTouchEventListener(handler(self, self.btnRightPageClick))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onPageItemRenderer))
	self.fields.Btn_help:fixPos()
end
function Com_info:onShow()
end
function Com_info:getBtnHelp()
	return self.fields.Btn_help
end
function Com_info:onPageItemRenderer(index, obj)
	obj:initPageData(self.additionCfg[index + 1], self.additionCfg[self.myLv])
end
function Com_info:initData(tag, ownCount, cfgCount)
	self.additionCfg = heroltCtrl:getHeroPalaceAdditionCfg(heroltCtrl:getHeroPalaceType(tag))
	self.pagesCount = #self.additionCfg
	self.myLv = 1
	for k, v in ipairs(self.additionCfg) do
		if ownCount >= v.totalHeroes then
			self.myLv = v.level
		end
	end
	self.curLv = self.myLv
	self.fields.List:setNumItems(self.pagesCount)
	self.fields.List:addEventListener(fgui.UIEventType.ScrollEnd, function()
		local itemIndex = self.fields.List:childIndexToItemIndex(0)
		self.curLv = itemIndex % self.pagesCount + 1
		print("==self.curLv==", itemIndex, self.curLv)
		self:setBtnLeftRight()
		self:setPageView()
	end)
	self.fields.List:scrollToView(self.curLv - 1)
	heroltCtrl = heroltCtrl:getHeroPalaceType(tag)
	heroltCtrl:getHeroPalaceType(tag).num1 = ownCount
	heroltCtrl:getHeroPalaceType(tag).num2 = cfgCount
	self.fields.Text_own:setString(i18n("hero_palace_text_15", heroltCtrl:getHeroPalaceType(tag)))
	self:setPageView()
	self:setBtnLeftRight()
end
function Com_info:setPageView()
	_ENV = nil
	;(nil).num = self.additionCfg[self.curLv].totalHeroes
	self.fields.Label_title:setString(i18n("hero_palace_text_04", nil))
end
function Com_info:btnLeftPageClick()
	SoraDPlaySound()
	self.curLv = math.min(self.pagesCount, self.curLv + 1)
	self.fields.List:scrollToView(self.curLv - 1, true)
end
function Com_info:btnRightPageClick()
	SoraDPlaySound()
	self.curLv = math.max(1, self.curLv - 1)
	self.fields.List:scrollToView(self.curLv - 1, true)
end
function Com_info:setBtnLeftRight()
	if self.curLv >= self.pagesCount then
		self.fields.btn_l:setVisible(false)
		self.fields.btn_r:setVisible(true)
	elseif self.curLv <= 1 then
		self.fields.btn_l:setVisible(true)
		self.fields.btn_r:setVisible(false)
	else
		self.fields.btn_l:setVisible(true)
		self.fields.btn_r:setVisible(true)
	end
end
function Com_info:btnHelpClick()
	SoraDPlaySound()
	uiManager:show("HeroTempleCrownHelp")
end
return Com_info
