local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local allianceDesRead = include("allianceDesRead")
local atlantisWarUtil = include("atlantisWarUtil")
local AMB = require_data("atlantiswar_map_build", true).data
local mapSyncUtilClient = include("mapSyncUtilClient")
local atlantisBossResultView = class("atlantisBossResultView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisBossResultView")
	end
	return target
end)
function atlantisBossResultView:ctor()
	self.notifyData, _UPVALUE0_, self.enableTouchCloseSelf = nil, nil, true
	self:initWidget()
end
function atlantisBossResultView:initWidget(...)
	_UPVALUE2_ = nil
	;(nil)[1] = "Top_Node_title"
	;(nil)[2] = "Text_title"
	self.Text_title = SoraDGetChildByFullPath(self._ccsView, nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "Top_Node_title"
	;(nil)[2] = "Button_close"
	self.Button_close = SoraDGetChildByFullPath(self._ccsView, nil)
	self.Button_close:addTouchEventListener(handler(self, self.close))
	_UPVALUE1_ = handler(self, self.close)
	handler(self, self.close)[1] = "Top_Size_ScrollView_1"
	self.scroll = SoraDGetChildByFullPath(self._ccsView, handler(self, self.close))
	_UPVALUE1_ = handler(self, self.close)
	handler(self, self.close)[1] = "Node_single"
	self.Node_single = SoraDGetChildByFullPath(self._ccsView, handler(self, self.close))
	self.Node_single:setVisible(false)
end
function atlantisBossResultView:initData(notifyData)
