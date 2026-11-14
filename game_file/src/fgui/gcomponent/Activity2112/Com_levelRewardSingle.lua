local snowyNightCarnivalCtrl = SoraDGetCtrl("snowyNightCarnivalCtrl")
local snowyNightCarnivalltCtrl = include("snowyNightCarnivalltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_levelRewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity2112/Com_levelRewardSingle", Com_levelRewardSingle)
function Com_levelRewardSingle:onInit()
	self:fixChildrenPos()
	_ENV = self.fixChildrenPos
	self.fixChildrenPos.unlock = false
	self.fixChildrenPos.gotNormal = false
	self.fixChildrenPos.gotExtra = false
	self.state, self.fixChildrenPos.levelState = self.fixChildrenPos, false
	self.fields.List_normal:setItemRenderer(handler(self, self.onItemRendererNormal))
	self.fields.List_extra:setItemRenderer(handler(self, self.onItemRendererExtra))
	if self.fields.Ani_signleSnow then
		self.fields.Ani_signleSnow:setAllFrameName("dh_Tex_XL_xykh02_%03d.png", 0)
		self.fields.Ani_signleSnow:setBlendFunc(gl.ONE, gl.ONE)
	end
end
function Com_levelRewardSingle:initData(index, data)
	self.level = index
	self.score = data.score
	self.normalData = snowyNightCarnivalltCtrl.getRewardConfigByLevel(self.level).normalreward
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.normalData = serviceFunctions.tableFormat(self.normalData, nil)
	self.extralData = snowyNightCarnivalltCtrl.getRewardConfigByLevel(self.level).specialreward
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.extralData = serviceFunctions.tableFormat(self.extralData, nil)
	self:setData()
	self.fields.Text_title:setString(tostring(index))
	self.fields.List_normal:setNumItems(table.nums(self.normalData))
	self.fields.List_extra:setNumItems(table.nums(self.extralData))
	self:setState()
end
function Com_levelRewardSingle:setData()
	self.state.unlock = snowyNightCarnivalCtrl:getUnlockFurther()
	self.state.gotNormal = snowyNightCarnivalCtrl:isInGotNormal(self.level)
	self.state.gotExtra = snowyNightCarnivalCtrl:isInGotExtra(self.level)
	self.state.levelState = snowyNightCarnivalCtrl:getLevelState(self.level, self.score)
	dump(self.state, "fsjkfksdfjkdfjkd")
	print(self.state.levelState and self.state.gotNormal)
	print(self.state.levelState and self.state.gotExtra)
end
function Com_levelRewardSingle:setState()
	if not (not self.state.levelState or self.state.gotNormal) or self.state.levelState and self.state.unlock and not self.state.gotExtra then
		self.controllers.state:setSelectedIndex(1)
	else
		self.controllers.state:setSelectedIndex(0)
	end
end
function Com_levelRewardSingle:onItemRendererNormal(index, object)
	object:initData(index + 1, self.normalData[index + 1], self.state.levelState, self.state.gotNormal, true, self.level)
end
function Com_levelRewardSingle:onItemRendererExtra(index, object)
	object:initData(index + 1, self.extralData[index + 1], self.state.levelState, self.state.gotExtra, self.state.unlock, self.level)
end
function Com_levelRewardSingle:onClickGetReward(context)
end
function Com_levelRewardSingle:onShow()
end
return Com_levelRewardSingle
