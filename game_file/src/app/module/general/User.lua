local User = class("User", cc.mvc.ModelBase)
User.EVENT_USER_RETRIEVED = "USER_RETRIEVED_EVENT"
User.schema = clone(cc.mvc.ModelBase.schema)
_UPVALUE1_ = cc.mvc.ModelBase.schema
User.schema.account, cc.mvc.ModelBase.schema[1] = cc.mvc.ModelBase.schema, "string"
_UPVALUE1_ = cc.mvc.ModelBase.schema
User.schema.proof, cc.mvc.ModelBase.schema[1] = cc.mvc.ModelBase.schema, "string"
function User:ctor(properties)
	User.super.ctor(self, properties)
end
function User:Auth()
end
function User:AuthSuccess()
	User = nil
	;(nil).name = User.EVENT_USER_RETRIEVED
	self:dispatchEvent(nil)
end
return User
