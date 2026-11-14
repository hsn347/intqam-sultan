local baseComponent = require("fgui.base.baseComponent")
local Com_accuSingle = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
local activity_9001573_Read = include("activity_9001573_Read")
fgui.register_extension("ui://Activity_9001573/Com_accuSingle", Com_accuSingle)
function Com_accuSingle:onInit()
	self:fixChildrenPos()
	self.fields.n0:fix(false)
	if SoraDFIsRA() then
		self.fields.Usm_1:setScaleX(-1)
	end
	self.fields.Ani_box:setAllFrameName("dh_jinengyj01_%03d.png", 0)
	self.fields.touch:addClickListener(handler(self, self.onClickGet))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.iconPosY = self.fields.icon:getPositionY()
end
function Com_accuSingle:initData(data, otherData)
	self.cfg = data
	self.fields.Text_score:setString(string.formatnumberthousands(self.cfg.point))
	self.reward, _ENV, self.state = activity_9001573_Ctrl:getPointRewardState(self.cfg.point, otherData), activity_9001573_Ctrl:getPointRewardState(self.cfg.point, otherData), activity_9001573_Ctrl:getPointRewardState(self.cfg.point, otherData)
	local lv = activity_9001573_Ctrl:getPowerRatio()
	local powerRatio = activity_9001573_Read.getRewardRatio(lv)
	for i, v in ipairs(self.cfg.reward) do
		_ENV = string.formatnumberthousands(self.cfg.point)
		string.formatnumberthousands(self.cfg.point).id = v.id
		string.formatnumberthousands(self.cfg.point).count = v.count
		table.insert(self.reward, string.formatnumberthousands(self.cfg.point))
	end
	print("powerRatio = ,", powerRatio)
	for i, v in ipairs(self.cfg.diffReward) do
		local addNum = math.floor(v.count * powerRatio / 1000)
		local isIn = false
		for i2, v2 in ipairs(self.reward) do
			if v2.id == v.id then
				isIn = true
				v2.count = v2.count + addNum
			end
		end
		if not isIn then
			_ENV = ipairs(self.reward)
			ipairs(self.reward).id = v.id
			ipairs(self.reward).count = addNum
			table.insert(self.reward, ipairs(self.reward))
		end
	end
	self.otherData = otherData
	print("self.state", self.state)
	self.fields.icon:setPositionY(self.iconPosY)
	self.fields.icon:setScale(1)
	if self.state == 0 then
		self.fields.icon:setURL((data.icon or "icon_starcube_box_01") .. ".png")
		self.controllers.c1:setSelectedIndex(0)
	elseif self.state == 2 then
		self.fields.icon:setURL((data.iconOpen or "icon_starcube_box_01_open") .. ".png")
		self.controllers.c1:setSelectedIndex(2)
		self.fields.icon:setPositionY(self.iconPosY + 8)
		self.fields.icon:setScale(0.98)
	else
		self.fields.icon:setURL((data.icon or "icon_starcube_box_01") .. ".png")
		self.controllers.c1:setSelectedIndex(1)
	end
	self.fields.List_reward:setNumItems(table.nums(self.reward))
	self.fields.List_reward:scrollToView(0)
end
function Com_accuSingle:onItemRenderer(index, object)
	object:initData(self.reward[index + 1].id, self.reward[index + 1].count, self.state == 1 and 1 or 0)
end
function Com_accuSingle:onClickGet()
	SoraDPlaySound()
	if self.state == 1 then
		activity_9001573_Ctrl:reqReceiveScoreReward(self.otherData)
	elseif self.state == 2 then
		SoraDShowMsgTip(i18n("common_text_1892"))
	else
		local myScore = activity_9001573_Ctrl:getMyPoint()
		_ENV = i18n("common_text_1892")
		i18n("common_text_1892").num = string.formatnumberthousands(self.cfg.point - myScore)
		SoraDShowMsgTip(i18n("nebula_war_text_0526", i18n("common_text_1892")))
	end
end
function Com_accuSingle:onShow()
	self.fields.icon:setPositionX(self.fields.touch:getPositionX())
end
return Com_accuSingle
