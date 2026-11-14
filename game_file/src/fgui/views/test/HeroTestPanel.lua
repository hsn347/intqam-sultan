local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroTestPanel = class("HeroTestPanel", baseFguiPanel)
function HeroTestPanel:ctor(...)
	HeroTestPanel.super.ctor(self, ...)
	print("HeroTestPanel:ctor", self.viewName)
end
function HeroTestPanel:onInit()
	print("=======HeroTestPanel:onInit")
	_UPVALUE5_, self.isHideCurrentSceneView = print, true
	self.heroTypeList, print[1] = print, 1
	self.heroTypeList, print[2] = print, 2
	self.heroTypeList, print[3] = print, 3
	self.heroTypeList, print[4] = print, 4
	self.heroTypeList, print[5] = print, 5
	self.index = 1
	self.fields.Com_title:initData(i18n("英雄测试"), handler(self, self.onClickClose))
	self.fields.Button_left:addClickListener(handler(self, self.btnLeftPageClick))
	self.fields.Button_right:addClickListener(handler(self, self.btnRightPageClick))
end
function HeroTestPanel:onShow()
	print("=======HeroTestPanel:onShow")
	self:initData()
end
function HeroTestPanel:initData()
	local heroType = self.heroTypeList[self.index]
	local _ENV, heroList = self.index, self.index
	for k, v in pairs(heroltCtrl.herosInfo) do
		if SoraDisInList(heroType, v.heroType) then
			_ENV = v.heroType
			v.heroType.dressID = v.dressUpId[1]
			v.heroType.hType = heroType
			table.insert(heroList, v.heroType)
		end
	end
	table.sort(heroList, function(a, b)
		return a.dressID < b.dressID
	end)
	for i = 1, 15 do
		self.fields["Spine_" .. i]:setVisible(false)
		if heroList[i] then
			local cfg = heroltCtrl.heroSpineCriDef[heroList[i].dressID]
			if cfg.isUsm then
				self.fields["Spine_" .. i]:setVisible(false)
			else
				self.fields["Spine_" .. i]:setVisible(true)
				self.fields["Spine_" .. i]:setEffectPath(string.format("spine/herosV/heroModle_%d.skel", heroList[i].dressID))
				self.fields["Spine_" .. i]:setScale(0.5)
				self.fields["Spine_" .. i]:setSpinePos(cc.p(0, -600))
				self.fields["Spine_" .. i]:pause()
			end
		end
	end
	self.fields.Com_title:updateTitle("英雄类型:" .. i18n(heroltCtrl.getHeroClassTypeName(heroType)))
end
function HeroTestPanel:btnLeftPageClick()
	SoraDPlaySound()
	self.index = self.index - 1
	if self.index < 1 then
		self.index = #self.heroTypeList
	end
	self:initData()
end
function HeroTestPanel:btnRightPageClick()
	SoraDPlaySound()
	self.index = self.index + 1
	if self.index > #self.heroTypeList then
		self.index = 1
	end
	self:initData()
end
return HeroTestPanel
