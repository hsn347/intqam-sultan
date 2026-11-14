local baseComponent = require("fgui.base.baseComponent")
local Com_armyDetail = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_armyDetail", Com_armyDetail)
function Com_armyDetail:onInit()
	self:fixChildrenPos()
	if not SoraDFIsRA() then
		self.fields.n2:setScaleX(-1)
		self.fields.n3:setScaleX(-1)
	end
	self.divineBeastStarPos = self.fields.Com_armyDetail_divinebeast:getPositionX()
	self.fields.list_hero:setItemRenderer(handler(self, self.onHeroRenderer))
	self.fields.list_lieutenant:setItemRenderer(handler(self, self.onLieutenantRenderer))
	self.fields.list_army:setTouchEnabled(false)
	self.fields.list_army:setItemRenderer(handler(self, self.onArmyRenderer))
end
function Com_armyDetail:onShow()
end
function Com_armyDetail:setTopHeight(height)
	self.fields.top_size:setSize(600, height)
	self.fields.layout:ensureBoundsCorrect()
end
function Com_armyDetail:setBottomHeight(height)
	self.fields.bottom_size:setSize(600, height)
	self.fields.layout:ensureBoundsCorrect()
end
function Com_armyDetail:initMassArmyData(info)
	self:setMemberInfo(info:getFrom())
	self:setHeros(info:getFromHero())
	self:setArmsAndDivineBeast(info:getFromArtifact(), info:getFromDivineBeastInfo())
	self:setArmyList(info:getFromArmy())
	self.fields.layout:ensureBoundsCorrect()
end
function Com_armyDetail:initSingleArmyData(info)
	self:setMemberInfo(nil)
	self:setHeros(info:getFromHero())
	self:setArmsAndDivineBeast(info:getFromArtifact(), info:getFromDivineBeastInfo())
	self:setArmyList(info:getFromArmy())
	self.fields.layout:ensureBoundsCorrect()
end
function Com_armyDetail:initMemberData(data)
	self:setMemberInfo(nil)
	self:setHeros(data.heroInfo)
	self:setArmsAndDivineBeast(data.armsInfo, data.divineBeastInfo)
	self:setArmyList(data.army or data.armyList)
	self.fields.layout:ensureBoundsCorrect()
end
function Com_armyDetail:setMemberInfo(data)
	self.fields.armSingle:setVisible(data ~= nil)
	if not data then
		return
	end
	self.fields.armSingle:initData(data)
end
function Com_armyDetail:setHeros(heros)
