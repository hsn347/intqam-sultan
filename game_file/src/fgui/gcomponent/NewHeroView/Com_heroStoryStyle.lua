local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroBiographyCtrl = SoraDGetCtrl("heroBiographyCtrl")
local heroBiographyRead = include("heroBiographyRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_heroStoryStyle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle)
_ENV, _UPVALUE2_, _ENV = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", fgui.register_extension
Com_heroStoryStyle.zorder = 2
_ENV, Com_heroStoryStyle.pos = cc.p(-10, 0), cc.p(-10, 0)
cc.p(-10, 0).zorder = 1
cc.p(-10, 0).pos = cc.p(90, 0)
_ENV, _UPVALUE3_, fgui.register_extension[1], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE3_, fgui.register_extension[1], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-10, 0)
Com_heroStoryStyle.zorder = 2
_ENV, Com_heroStoryStyle.pos = cc.p(-125, 0), cc.p(-125, 0)
cc.p(-125, 0).zorder = 3
_ENV, cc.p(-125, 0).pos = cc.p(155, 20), cc.p(155, 20)
cc.p(155, 20).zorder = 1
cc.p(155, 20).pos = cc.p(85, -177)
_ENV, _UPVALUE2_, fgui.register_extension[2], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE2_, fgui.register_extension[2], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-125, 0)
_ENV, _UPVALUE2_, fgui.register_extension[2], ("ui://NewHeroView/Com_heroStoryStyle")[3] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(155, 20)
_ENV, Com_heroStoryStyle.pos = cc.p(115, -50), cc.p(115, -50)
cc.p(115, -50).pos = cc.p(-112, 0)
_ENV, _UPVALUE3_, fgui.register_extension[3], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE3_, fgui.register_extension[3], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(115, -50)
Com_heroStoryStyle.zorder = 1
_ENV, Com_heroStoryStyle.pos = cc.p(-49, -128), cc.p(-49, -128)
cc.p(-49, -128).zorder = 3
_ENV, cc.p(-49, -128).pos = cc.p(-28.5, 148), cc.p(-28.5, 148)
cc.p(-28.5, 148).zorder = 2
cc.p(-28.5, 148).pos = cc.p(133.5, 0)
_ENV, _UPVALUE2_, fgui.register_extension[4], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE2_, fgui.register_extension[4], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-49, -128)
_ENV, _UPVALUE2_, fgui.register_extension[4], ("ui://NewHeroView/Com_heroStoryStyle")[3] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-28.5, 148)
Com_heroStoryStyle.zorder = 2
_ENV, Com_heroStoryStyle.pos = cc.p(92, 70), cc.p(92, 70)
cc.p(92, 70).zorder = 1
cc.p(92, 70).pos = cc.p(-121, -70)
_ENV, _UPVALUE2_, fgui.register_extension[5], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE2_, fgui.register_extension[5], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(92, 70)
_ENV, Com_heroStoryStyle.pos = cc.p(53, -50), cc.p(53, -50)
cc.p(53, -50).pos = cc.p(-70, 115)
_ENV, _UPVALUE3_, fgui.register_extension[6], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE3_, fgui.register_extension[6], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(53, -50)
Com_heroStoryStyle.zorder = 3
_ENV, Com_heroStoryStyle.pos = cc.p(-20, 165), cc.p(-20, 165)
cc.p(-20, 165).zorder = 1
_ENV, cc.p(-20, 165).pos = cc.p(-17, -92), cc.p(-17, -92)
cc.p(-17, -92).zorder = 2
cc.p(-17, -92).pos = cc.p(170, 98)
_ENV, _UPVALUE3_, fgui.register_extension[7], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE3_, fgui.register_extension[7], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-20, 165)
_ENV, _UPVALUE3_, fgui.register_extension[7], ("ui://NewHeroView/Com_heroStoryStyle")[3] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-17, -92)
Com_heroStoryStyle.zorder = 3
_ENV, Com_heroStoryStyle.pos = cc.p(-148, 142), cc.p(-148, 142)
cc.p(-148, 142).zorder = 2
_ENV, cc.p(-148, 142).pos = cc.p(181.5, 92), cc.p(181.5, 92)
cc.p(181.5, 92).zorder = 1
cc.p(181.5, 92).pos = cc.p(-18, -92)
_ENV, _UPVALUE3_, fgui.register_extension[8], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE3_, fgui.register_extension[8], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-148, 142)
_ENV, _UPVALUE3_, fgui.register_extension[8], ("ui://NewHeroView/Com_heroStoryStyle")[3] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(181.5, 92)
Com_heroStoryStyle.zorder = 2
_ENV, Com_heroStoryStyle.pos = cc.p(60, 44), cc.p(60, 44)
cc.p(60, 44).zorder = 3
_ENV, cc.p(60, 44).pos = cc.p(-19, 128), cc.p(-19, 128)
cc.p(-19, 128).zorder = 1
cc.p(-19, 128).pos = cc.p(-16, -177)
_ENV, _UPVALUE2_, fgui.register_extension[9], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE2_, fgui.register_extension[9], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(60, 44)
_ENV, _UPVALUE2_, fgui.register_extension[9], ("ui://NewHeroView/Com_heroStoryStyle")[3] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-19, 128)
Com_heroStoryStyle.zorder = 2
_ENV, Com_heroStoryStyle.pos = cc.p(101, 52), cc.p(101, 52)
cc.p(101, 52).zorder = 1
cc.p(101, 52).pos = cc.p(-150, 0)
_ENV, _UPVALUE2_, fgui.register_extension[10], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE2_, fgui.register_extension[10], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(101, 52)
Com_heroStoryStyle.zorder = 2
_ENV, Com_heroStoryStyle.pos = cc.p(47, 0), cc.p(47, 0)
cc.p(47, 0).zorder = 1
cc.p(47, 0).pos = cc.p(-90, 0)
_ENV, _UPVALUE2_, fgui.register_extension[11], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE2_, fgui.register_extension[11], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(47, 0)
_ENV, Com_heroStoryStyle.pos = cc.p(-25, -140), cc.p(-25, -140)
cc.p(-25, -140).pos = cc.p(-63, 70)
_ENV, _UPVALUE3_, fgui.register_extension[12], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE3_, fgui.register_extension[12], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-25, -140)
Com_heroStoryStyle.zorder = 2
_ENV, Com_heroStoryStyle.pos = cc.p(-96, -120), cc.p(-96, -120)
cc.p(-96, -120).zorder = 3
_ENV, cc.p(-96, -120).pos = cc.p(-44, 100), cc.p(-44, 100)
cc.p(-44, 100).zorder = 1
cc.p(-44, 100).pos = cc.p(97, -170)
_ENV, _UPVALUE2_, fgui.register_extension[13], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE2_, fgui.register_extension[13], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-96, -120)
_ENV, _UPVALUE2_, fgui.register_extension[13], ("ui://NewHeroView/Com_heroStoryStyle")[3] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-44, 100)
_ENV, Com_heroStoryStyle.pos = cc.p(-58, 0), cc.p(-58, 0)
cc.p(-58, 0).pos = cc.p(60, 0)
_ENV, _UPVALUE3_, fgui.register_extension[14], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE3_, fgui.register_extension[14], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-58, 0)
Com_heroStoryStyle.zorder = 3
_ENV, Com_heroStoryStyle.pos = cc.p(-100, 100), cc.p(-100, 100)
cc.p(-100, 100).zorder = 1
_ENV, cc.p(-100, 100).pos = cc.p(93, -100), cc.p(93, -100)
cc.p(93, -100).zorder = 2
cc.p(93, -100).pos = cc.p(190, -47)
_ENV, _UPVALUE3_, fgui.register_extension[15], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE3_, fgui.register_extension[15], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-100, 100)
_ENV, _UPVALUE3_, fgui.register_extension[15], ("ui://NewHeroView/Com_heroStoryStyle")[3] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(93, -100)
Com_heroStoryStyle.zorder = 1
_ENV, Com_heroStoryStyle.pos = cc.p(100, -100), cc.p(100, -100)
cc.p(100, -100).zorder = 3
_ENV, cc.p(100, -100).pos = cc.p(135, 112), cc.p(135, 112)
cc.p(135, 112).zorder = 2
cc.p(135, 112).pos = cc.p(-148, 165)
_ENV, _UPVALUE3_, fgui.register_extension[16], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE3_, fgui.register_extension[16], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(100, -100)
_ENV, _UPVALUE3_, fgui.register_extension[16], ("ui://NewHeroView/Com_heroStoryStyle")[3] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(135, 112)
_ENV, Com_heroStoryStyle.pos = cc.p(120, -60), cc.p(120, -60)
_ENV, cc.p(120, -60).pos = cc.p(-40, 135), cc.p(-40, 135)
cc.p(-40, 135).pos = cc.p(50, 127)
_ENV, _UPVALUE3_, fgui.register_extension[17], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE3_, fgui.register_extension[17], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(120, -60)
_ENV, _UPVALUE3_, fgui.register_extension[17], ("ui://NewHeroView/Com_heroStoryStyle")[3] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-40, 135)
Com_heroStoryStyle.zorder = 1
_ENV, Com_heroStoryStyle.pos = cc.p(0, -45), cc.p(0, -45)
cc.p(0, -45).zorder = 3
_ENV, cc.p(0, -45).pos = cc.p(-90, 187), cc.p(-90, 187)
cc.p(-90, 187).zorder = 2
cc.p(-90, 187).pos = cc.p(135, 57)
_ENV, _UPVALUE3_, fgui.register_extension[18], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE3_, fgui.register_extension[18], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(0, -45)
_ENV, _UPVALUE3_, fgui.register_extension[18], ("ui://NewHeroView/Com_heroStoryStyle")[3] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-90, 187)
Com_heroStoryStyle.zorder = 3
_ENV, Com_heroStoryStyle.pos = cc.p(0, 134), cc.p(0, 134)
cc.p(0, 134).zorder = 1
_ENV, cc.p(0, 134).pos = cc.p(116, -40), cc.p(116, -40)
cc.p(116, -40).zorder = 2
cc.p(116, -40).pos = cc.p(-165, 57)
_ENV, _UPVALUE3_, fgui.register_extension[19], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE3_, fgui.register_extension[19], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(0, 134)
_ENV, _UPVALUE3_, fgui.register_extension[19], ("ui://NewHeroView/Com_heroStoryStyle")[3] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(116, -40)
Com_heroStoryStyle.zorder = 2
_ENV, Com_heroStoryStyle.pos = cc.p(-65, 190), cc.p(-65, 190)
cc.p(-65, 190).zorder = 3
_ENV, cc.p(-65, 190).pos = cc.p(170, 126), cc.p(170, 126)
cc.p(170, 126).zorder = 1
cc.p(170, 126).pos = cc.p(0, -50)
_ENV, _UPVALUE3_, fgui.register_extension[20], ("ui://NewHeroView/Com_heroStoryStyle")[1] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
_ENV, _UPVALUE3_, fgui.register_extension[20], ("ui://NewHeroView/Com_heroStoryStyle")[2] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(-65, 190)
_ENV, _UPVALUE3_, fgui.register_extension[20], ("ui://NewHeroView/Com_heroStoryStyle")[3] = Com_heroStoryStyle, "ui://NewHeroView/Com_heroStoryStyle", "ui://NewHeroView/Com_heroStoryStyle", cc.p(170, 126)
Com_heroStoryStyle.zorder = 1
_ENV, Com_heroStoryStyle.pos = cc.p(80, -180), cc.p(80, -180)
cc.p(80, -180).zorder = 3
_ENV, cc.p(80, -180).pos = cc.p(65, 200), cc.p(65, 200)
cc.p(65, 200).zorder = 2
cc.p(65, 200).pos = cc.p(-60, 110)
fgui.register_extension[21], ("ui://NewHeroView/Com_heroStoryStyle")[1] = "ui://NewHeroView/Com_heroStoryStyle", Com_heroStoryStyle
fgui.register_extension[21], ("ui://NewHeroView/Com_heroStoryStyle")[2] = "ui://NewHeroView/Com_heroStoryStyle", cc.p(80, -180)
fgui.register_extension[21], ("ui://NewHeroView/Com_heroStoryStyle")[3] = "ui://NewHeroView/Com_heroStoryStyle", cc.p(65, 200)
local config = fgui.register_extension
function Com_heroStoryStyle:onInit()
end
function Com_heroStoryStyle:onShow()
end
function Com_heroStoryStyle:initData(index, parent)
	self.parent = parent
	local status = heroBiographyCtrl:getHeroStoryStatus(index)
	if self.index == index then
		for i, item in ipairs(self.itemList) do
			item:updateStage(status)
		end
		return
	end
	self.index = index
	self:removeChildren()
	self.itemList, heroBiographyCtrl = self.removeChildren, self.removeChildren
	local heroList = heroBiographyRead.getHeroListByStoryIndex(index)
	dump(heroList, "heroList")
	local heroBiographyCtrl, realSortHero = dump, dump
	for k, v in ipairs(heroList) do
		heroBiographyCtrl = nil
		;(nil).heroID = v
		realSortHero[config[index][k].zorder or k], (nil).idx = nil, k
	end
	dump(realSortHero, "realSortHero")
	for k, v in ipairs(realSortHero) do
		local clickItem = fgui.UIPackage:createObjectFromURL(string.format("ui://NewHeroView/Hero%s", v.heroID))
		local item = fgui.UIPackage:createObjectFromURL("ui://NewHeroView/Com_HeroSpineUsm")
		clickItem:setPivot(0.5, 0.5, true)
		clickItem:addTo(self)
		clickItem:setName(tostring(v.heroID))
		item:setPivot(0.5, 0.5, true)
		item:addTo(self)
		item:initData(v.heroID, status)
		item:setPosition(config[index][v.idx].pos)
		clickItem:setPosition(config[index][v.idx].pos)
		local cfg, _ = heroltCtrl:getHeroSpineCfg(v.heroID)
		if cfg then
			clickItem:setScale(cfg.binaryNew[4], cfg.binaryNew[5])
		end
		clickItem:setAlpha(0.01)
		clickItem:addClickListener(handlerEx(self, self.onClickItem, v.heroID))
		table.insert(self.itemList, item)
	end
end
function Com_heroStoryStyle:onClickItem(heroID)
	SoraDPlaySound()
	if heroCtrl:getHeroInfoByID(heroID) then
		SoraDShowHeroDetailView(heroID)
	else
		local itemNum, needNum, itemID, isEnough = heroltCtrl:judgeUpgradeItem(heroID)
		if isEnough then
			_ENV = nil
			;(nil).jumpUnlockHero = heroID
			uiManager:show("newHeroListView", nil)
		else
			_ENV = nil
			;(nil).itemID = itemID
			;(nil).needCount = needNum
			;(nil).noExchange = true
			uiManager:show("newHeroGainChipMethodView", nil)
		end
	end
end
return Com_heroStoryStyle
