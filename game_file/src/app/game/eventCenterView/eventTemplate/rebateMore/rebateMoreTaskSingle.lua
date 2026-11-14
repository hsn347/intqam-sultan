local gametop = gModuleMgr.getObject("gametop")
local cumuActiveCtrl = gametop.playertop_:getModule("cumuActiveCtrl")
_ENV = gametop.playertop_
gametop.playertop_.noClaim = 1
gametop.playertop_.noReach = 2
local gametop.playertop_.claimed, giftStatus = 3, gametop.playertop_
local rebateMoreTaskSingle = class("rebateMoreTaskSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rebateMoreTaskSingle")
	end
	return target
end)
function rebateMoreTaskSingle:ctor(...)
	self.award, _ENV = nil, nil
	self.Node_award = SoraDGetChildByName(self, "Node_award")
	self.Text_dsc = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_dsc"))
	self.Text_rem = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_rem"))
	self.img_box = SoraDGetChildByName(self, "img_box")
	self.CCS_commonItemAward_1 = SoraDGetChildByName(self, "CCS_commonItemAward_1")
	self.CCS_commonItemAward_1:setVisible(false)
	self.Text_time = SoraDGetChildByName(self, "Text_23")
end
function rebateMoreTaskSingle:onMessageListener(...)
end
function rebateMoreTaskSingle:initData(data, otherData)
	self.data = data
	local left = self.data.left
	self.scroll = otherData.scroll
	self.view = otherData.view
	if type(self.data.range) == "number" then
		_ENV = nil
		_ENV, _ENV, (nil).num1 = self.data.range, string.formatnumberthousands(self.data.range), string.formatnumberthousands(self.data.range)
		self.data.range.color = "#ffff00"
		_ENV, string.formatnumberthousands(self.data.range).num1, self.data.range.i = self.data.range, self.data.range, "true"
		string.formatnumberthousands(self.data.range).__default, self.data.range.color = self.data.range, "#aa9682"
		self.Text_dsc:setString(i18n_html("rebate_many_text_04", nil, (string.formatnumberthousands(self.data.range))))
	elseif type(self.data.range) == "table" then
		_ENV = i18n_html("rebate_many_text_04", nil, (string.formatnumberthousands(self.data.range)))
		i18n_html("rebate_many_text_04", nil, (string.formatnumberthousands(self.data.range))).num1 = string.formatnumberthousands(self.data.range.from)
		_ENV, _ENV, i18n_html("rebate_many_text_04", nil, (string.formatnumberthousands(self.data.range))).num2 = self.data.range.to, string.formatnumberthousands(self.data.range.to), string.formatnumberthousands(self.data.range.to)
		self.data.range.to.color = "#ffff00"
		_ENV, string.formatnumberthousands(self.data.range.to).num1, self.data.range.to.i = self.data.range.to, self.data.range.to, "true"
		self.data.range.to.color = "#ffff00"
		_ENV, string.formatnumberthousands(self.data.range.to).num2, self.data.range.to.i = self.data.range.to, self.data.range.to, "true"
		string.formatnumberthousands(self.data.range.to).__default, self.data.range.to.color = self.data.range.to, "#aa9682"
		self.Text_dsc:setString(i18n_html("rebate_many_text_03", i18n_html("rebate_many_text_04", nil, (string.formatnumberthousands(self.data.range)))))
	end
	_ENV = i18n_html("rebate_many_text_03", i18n_html("rebate_many_text_04", nil, (string.formatnumberthousands(self.data.range))))
	i18n_html("rebate_many_text_03", i18n_html("rebate_many_text_04", nil, (string.formatnumberthousands(self.data.range)))).num1 = tostring(left)
	_ENV, i18n_html("rebate_many_text_03", i18n_html("rebate_many_text_04", nil, (string.formatnumberthousands(self.data.range)))).num2 = tostring(self.data.limit), tostring(self.data.limit)
	if left == 0 then
		_ENV = self.data.limit
		self.data.limit.color = "#FF0000"
		if self.data.limit then
			goto lbl_98
		end
	end
	_ENV = self.data.limit
	_ENV, tostring(self.data.limit).num1, self.data.limit.color = self.data.limit, self.data.limit, "#FFFFFF"
	::lbl_98::
	tostring(self.data.limit).__default, self.data.limit.color = self.data.limit, "#FFFFFF"
	self.Text_rem:setString(i18n_html("rebate_many_text_02", i18n_html("rebate_many_text_03", i18n_html("rebate_many_text_04", nil, (string.formatnumberthousands(self.data.range))))))
	self:setReward()
	self.img_box:setSpriteFrame(data.index > 4 and "icon_magicpalace_box_04.png" or "icon_magicpalace_box_0" .. data.index .. ".png")
end
function rebateMoreTaskSingle:setReward()
	local reward = self.data.reward
	for index = 1, table.nums(reward) do
		local data = reward[index]
		local itemAward = self.award[index]
		if itemAward then
			itemAward:initData(data.id, data.count)
		else
			itemAward = include("commonItemAward").new()
			itemAward:setRealScale(0.95)
			itemAward:setOwnScroll(self.scroll)
			itemAward:setOwnView(self.view)
			itemAward:setPosition(0, 0)
			itemAward:addTo(self.Node_award)
			itemAward:initData(data.id, data.count)
			self.award[index] = itemAward
		end
	end
	SoraDToCenter(self.Node_award, 85, SoraDFIsRA())
end
return rebateMoreTaskSingle
