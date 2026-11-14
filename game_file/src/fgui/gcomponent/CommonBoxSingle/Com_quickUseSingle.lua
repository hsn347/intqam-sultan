local publicRead = include("publicRead")
local itemLogic = include("itemLogic")
local itemDesRead = include("itemDesRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_quickUseSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonBoxSingle/Com_quickUseSingle", Com_quickUseSingle)
function Com_quickUseSingle:onInit()
	self.fields.Button_use:setString(i18n("common_text_314"))
	self.fields.Button_use:addClickListener(handler(self, self.btnUseClick))
	self:fixChildrenPos()
end
function Com_quickUseSingle:onShow()
end
function Com_quickUseSingle:initData(data, needID)
	self.data = data
	self.needID = needID
	self.fields.item:initData(self.data.id, self.data.count)
	self.fields.Text_name:setString(publicRead.getName(self.data.id))
	local count = self:getResultCount(self.data.id)
	publicRead = publicRead.getName(self.data.id)
	publicRead.getName(self.data.id).name = publicRead.getName(self.needID)
	publicRead.getName(self.data.id).var = count
	self.fields.Text_des:setString(i18n("quick_use_02", publicRead.getName(self.data.id)))
	self.fields.Button_use:setBright(self.data.count > 0)
end
function Com_quickUseSingle:getResultCount(id)
	local count = 0
	local result = backpackltCtrl:getResult(id)
	if result and next(result) then
		if type(result[1]) == "number" then
			for i = 1, #result, 2 do
				if result[i] == self.needID then
					count = math.max(count, result[i + 1])
				end
			end
		else
			for i, v in ipairs(result) do
				if v.id == self.needID then
					count = math.max(count, v.count)
				end
			end
		end
	end
	return count
end
function Com_quickUseSingle:btnUseClick()
	SoraDPlaySound()
	if self.data.count > 0 then
		itemLogic.useItemsLine(self.data.id, self.data.count)
	else
		local key = itemDesRead.getGetWayLanKeyByID(self.data.id)
		if key then
			SoraDShowMsgTip(i18n(key))
		else
			SoraDShowMsgTip(i18n("Glory_text_61"))
		end
	end
end
return Com_quickUseSingle
