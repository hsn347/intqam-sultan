local starCubeCtrl = SoraDGetCtrl("starCubeCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_accuSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarEnergyCube/Com_accuSingle", Com_accuSingle)
function Com_accuSingle:onInit()
	self:fixChildrenPos()
	self.fields.n0:fix(false)
	if SoraDGetDefaultLanguage() ~= "ar" then
		self.fields.Usm_1:setScaleX(-1)
	end
	self.fields.Ani_box:setAllFrameName("dh_jinengyj01_%03d.png", 0)
	self.fields.touch:addClickListener(handler(self, self.onClickGet))
	self.fields.List_reward:setVirtual()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_accuSingle:initData(index, data)
	self.index = index
	self.score = data.totalOpenNum
	self.reward = data.numReward
	self.fields.Text_score:setString(self.score)
	self.state = 1
	if starCubeCtrl:getTotalOpenTimes() < self.score then
		self.fields.icon:setURL(data.boxIconNormal .. ".png")
		self.controllers.c1:setSelectedIndex(0)
	elseif not starCubeCtrl:isInStageReward(self.index) and starCubeCtrl:getTotalOpenTimes() >= self.score then
		self.state = 2
		self.fields.icon:setURL(data.boxIconNormal .. ".png")
		self.controllers.c1:setSelectedIndex(1)
	else
		self.state = 3
		self.fields.icon:setURL(data.boxIconOpened .. ".png")
		self.controllers.c1:setSelectedIndex(2)
		self.fields.icon:setPositionY(self.fields.icon:getPositionY() + 8)
		self.fields.icon:setScale(0.98)
	end
	self.fields.List_reward:setNumItems(table.nums(self.reward) / 2)
end
function Com_accuSingle:onItemRenderer(index, object)
	object:initData(self.reward[index * 2 + 1], self.reward[index * 2 + 2], self.state == 3)
end
function Com_accuSingle:onClickGet()
	if self.state == 2 then
		starCubeCtrl:reqStarCubeStageReward(self.index)
	end
end
function Com_accuSingle:onShow()
	self.fields.icon:setPositionX(self.fields.touch:getPositionX())
end
return Com_accuSingle
