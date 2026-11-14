local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001660_Ctrl = SoraDGetCtrl("activity_9001660_Ctrl")
local activity_9001660_Read = include("activity_9001660_Read")
local baseComponent = require("fgui.base.baseComponent")
local list_popbox = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001660/list_popbox", list_popbox)
function list_popbox:onInit()
	self.rewardList, _ENV, self.needList, _ENV = nil, nil, nil, nil
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardRenderer))
	self.fields.Text_need:setString(i18n("mutated_tentacles_text16"))
	self.fields.Label_title:setString(i18n("anniversary_btn_01"))
	self.fields.Button_exchange:setString(i18n("common_text_1889"))
	self.fields.Button_exchange:addClickListener(handler(self, self.btnExchangeClick))
	self:fixChildrenPos()
	self.fields.arrow:setRotation(SoraDFIsRA() and -90 or 90)
	self.fields.nbg:fix()
end
function list_popbox:onShow()
end
function list_popbox:onItemRenderer(index, obj)
	local data = self.needList[index + 1]
	obj:initData(data.id, backpackCtrl:getItemCount(data.id), data.count)
end
function list_popbox:onRewardRenderer(index, obj)
	obj:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
function list_popbox:initData(data, index)
	self.data = data
	self.index = index
	self.fields.Text_name:setString(i18n(self.data.boxName))
	self.fields.Text_name:setColor(SoraDHtmlColor2RGB(self.data.color))
	self.fields.box:setIcon(self.data.picture)
	_UPVALUE2_ = self.data.picture
	self.data.picture[1] = "id"
	self.data.picture[2] = "count"
	self.needList = serviceFunctions.tableFormat(self.data.needItem, self.data.picture)
	self.fields.List:setNumItems(#self.needList)
	_UPVALUE2_ = #self.needList
	;(#self.needList)[1] = "id"
	;(#self.needList)[2] = "count"
	self.rewardList = serviceFunctions.tableFormat(self.data.rewards, #self.needList)
	self.fields.List_reward:setNumItems(#self.rewardList)
	self.fields.Button_exchange:setEnabled(self:isCanExchange())
	self.fields.Button_exchange:setReddot(self:isCanExchange(), -1)
end
function list_popbox:isCanExchange()
	local ret = true
	for k, v in ipairs(self.needList) do
		if backpackCtrl:getItemCount(v.id) < v.count then
			ret = false
			break
		end
	end
	return ret
end
function list_popbox:btnExchangeClick()
	SoraDPlaySound()
	if not self:isCanExchange() then
		SoraDShowMsgTip(i18n("mutated_tentacles_text5"))
		return
	end
	activity_9001660_Ctrl:feathershopbuyReq(self.data.index)
end
return list_popbox
