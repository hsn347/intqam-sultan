local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local baseComponent = require("fgui.base.baseComponent")
local ReinforcementsSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildEmbassy/ReinforcementsSingle", ReinforcementsSingle)
function ReinforcementsSingle:onInit()
	self.fields.Com_touch:addClickListener(handler(self, self.btnUnfoldCallBack))
	self.fields.Text_postion:addClickListener(handler(self, self.panelPosClick))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.Image_arrow:setScaleY(-1)
	end
end
function ReinforcementsSingle:onShow()
end
function ReinforcementsSingle:initData(armyparty, isFold)
	self.tableArmy = armyparty
	if isFold then
		self.isFold = isFold
	end
	self:update()
end
function ReinforcementsSingle:update()
	self.fields.Text_name:setString(self.tableArmy.name)
	self.fields.Com_head:setHeadSprite(self.tableArmy.headIcon, self.tableArmy.avatar)
	_ENV = nil
	;(nil).count = string.formatnumberthousands(self.tableArmy.totalPower)
	self.fields.Text_battlePower:setString(i18n("common_text_555", nil))
	_ENV = i18n("common_text_555", nil)
	i18n("common_text_555", nil).x = self.tableArmy.pos.x
	i18n("common_text_555", nil).y = self.tableArmy.pos.y
	local posStr = i18n("common_text_2155", i18n("common_text_555", nil))
	_ENV = i18n("common_text_555", nil)
	i18n("common_text_555", nil).u = true
	self.fields.Text_postion:setString(SoraDWrapHtmlTagByStyle(posStr, i18n("common_text_555", nil)))
	self.totalArmyCount = 0
	for i, v in ipairs(self.tableArmy.armylist) do
		self.totalArmyCount = self.totalArmyCount + v.num
	end
	_ENV = SoraDWrapHtmlTagByStyle(posStr, i18n("common_text_555", nil))
	SoraDWrapHtmlTagByStyle(posStr, i18n("common_text_555", nil)).count = string.formatnumberthousands(self.totalArmyCount)
	self.fields.Text_armyCount:setString(i18n("common_text_556", SoraDWrapHtmlTagByStyle(posStr, i18n("common_text_555", nil))))
	if self.isFold == false then
		self:meFoldOrNot()
	end
end
function ReinforcementsSingle:btnUnfoldCallBack()
	SoraDPlaySound()
	self:meFoldOrNot()
end
function ReinforcementsSingle:panelPosClick()
	SoraDPlaySound()
	if self.tableArmy.pos then
		SoraDGotoWorldMapPoint(cc.p(self.tableArmy.pos.x, self.tableArmy.pos.y), true)
		SoraDRemoveAllPanelFromManager()
	end
end
function ReinforcementsSingle:meFoldOrNot()
	if self.isFold then
		self.isFold = false
		self.fields.Image_arrow:setRotation(SoraDFPosX(0, 180))
		if not self.Com_army then
			local Com_army = fgui.UIPackage:createObject("BuildEmbassy", "Com_army")
			Com_army:addTo(self.fields.Com_army)
			self.Com_army = Com_army
			local _fields = fguiHelper.get_fields(Com_army)
			_fields.Button_goHome:setString(i18n("common_text_302"))
			_fields.Button_goHome:addClickListener(handler(self, self.btnGoHomeCallBack))
			self.Com_armyDetail = _fields.Com_armyDetail
		end
		_ENV = _fields.Com_armyDetail
		_fields.Com_armyDetail.heroInfo = self.tableArmy.heroList
		_fields.Com_armyDetail.armsInfo = self.tableArmy.armsList
		_fields.Com_armyDetail.divineBeastInfo = self.tableArmy.divineBeastList
		_fields.Com_armyDetail.army = self.tableArmy.armylist
		self.Com_armyDetail:initMemberData(_fields.Com_armyDetail)
		self.Com_armyDetail:setImageBgHeightOffset(75)
		self:setHeight(118 + self.Com_army:getHeight())
	else
		self.isFold = true
		self.fields.Image_arrow:setRotation(90)
		if self.Com_army then
			self.Com_army:removeFromParent()
			self.Com_army = nil
		end
		self:setHeight(118)
	end
	if self.handlRepatriate then
		self.handlRepatriate()
	end
end
function ReinforcementsSingle:setRepatriateCallBack(handl)
	self.handlRepatriate = handl
end
function ReinforcementsSingle:btnGoHomeCallBack()
	SoraDPlaySound()
	kingdomMapCtrl:reqBackQueueById(self.tableArmy.qid)
end
return ReinforcementsSingle
