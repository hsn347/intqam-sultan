local starryNightCarnivalCtrl = SoraDGetCtrl("starryNightCarnivalCtrl")
local starryNightCarnivalltCtrl = include("starryNightCarnivalltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_levelRewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarryNightCarnival/Com_levelRewardSingle", Com_levelRewardSingle)
function Com_levelRewardSingle:onInit()
	self:fixChildrenPos()
	self.fields.n1:fix(false)
	self.fields.n2:fix(false)
	_ENV, self.notInit = self.fields.n2.fix, true
	self.fields.n2.fix.unlock = false
	self.fields.n2.fix.unlock2 = false
	self.fields.n2.fix.gotNormal = false
	self.fields.n2.fix.gotExtra = false
	self.fields.n2.fix.gotExtra2 = false
	self.state, self.fields.n2.fix.levelState = self.fields.n2.fix, false
	self.fields.List_normal:setItemRenderer(handler(self, self.onItemRendererNormal))
	self.fields.List_extra:setItemRenderer(handler(self, self.onItemRendererExtra))
	self.fields.List_extra2:setItemRenderer(handler(self, self.onItemRendererExtra2))
end
function Com_levelRewardSingle:initData(index, config, special, isAdd)
	self.level = index
	self.score = config.score
	self.special = special
	self.isAdd = isAdd
	self.normalData = config.normalReward
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.normalData = serviceFunctions.tableFormat(self.normalData, nil)
	self.extralData = config.advanceReward
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.extralData = serviceFunctions.tableFormat(self.extralData, nil)
	self.extral2Data = config.seniorReward
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.extral2Data = serviceFunctions.tableFormat(self.extral2Data, nil)
	self:setData()
	self.fields.Text_title:setString(isAdd and index .. "+" or tostring(index))
	self.fields.Text_title:setColor(self.level == starryNightCarnivalCtrl:getCanGetLevel() and cc.c3b(255, 215, 95, 1) or cc.c3b(255, 255, 255, 1))
	self.fields.List_normal:setNumItems(table.nums(self.normalData))
	self.fields.List_extra:setNumItems(table.nums(self.extralData))
	self.fields.List_extra2:setNumItems(table.nums(self.extral2Data))
	self:setState()
	if special then
		self.fields.Text_title:setColor(cc.c3b(255, 215, 95, 1))
		self.controllers.state:setSelectedIndex(0)
	end
end
function Com_levelRewardSingle:setData()
	self.state.unlock = starryNightCarnivalCtrl:getUnlockFurther()
	self.state.unlock2 = starryNightCarnivalCtrl:getUnlockFurtherEx()
	self.state.gotNormal = starryNightCarnivalCtrl:isInGotNormal(self.level) and not self.isAdd
	self.state.gotExtra = starryNightCarnivalCtrl:isInGotExtra(self.level) and not self.isAdd
	self.state.gotExtra2 = starryNightCarnivalCtrl:isInGotExtra2(self.level) and not self.isAdd
	if not self.isAdd then
		self.state.levelState = starryNightCarnivalCtrl:getLevelState(self.level, self.score)
	else
		self.state.levelState = starryNightCarnivalCtrl:getLevelState(self.level, self.score) and starryNightCarnivalCtrl:haveRewardNotGot()
	end
end
function Com_levelRewardSingle:setState()
	if self.state.levelState then
		self.controllers.state:setSelectedIndex(1)
		if self.notInit then
			self.notInit = false
			self.fields.Ani_canget1:setAllFrameName("dh_xingyekhnew_%02d.png", 1)
			self.fields.Ani_canget1:setPlaySettings(0, -1, -1)
			self.fields.Ani_canget2:setAllFrameName("dh_xingyekhnew_%02d.png", 1)
			self.fields.Ani_canget2:setPlaySettings(0, -1, -1)
			self.fields.Ani_canget3:setAllFrameName("dh_xingyekhnew_%02d.png", 1)
			self.fields.Ani_canget3:setPlaySettings(0, -1, -1)
		end
	else
		self.controllers.state:setSelectedIndex(0)
	end
end
function Com_levelRewardSingle:onItemRendererNormal(index, object)
	object:initData(index + 1, self.normalData[index + 1], self.state.levelState, self.state.gotNormal, true, self.level, self.special)
end
function Com_levelRewardSingle:onItemRendererExtra(index, object)
	object:initData(index + 1, self.extralData[index + 1], self.state.levelState, self.state.gotExtra, self.state.unlock, self.level, self.special)
end
function Com_levelRewardSingle:onItemRendererExtra2(index, object)
	object:initData(index + 1, self.extral2Data[index + 1], self.state.levelState, self.state.gotExtra2, self.state.unlock2, self.level, self.special)
end
function Com_levelRewardSingle:onShow()
end
return Com_levelRewardSingle
