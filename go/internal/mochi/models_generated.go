// Code generated by nimona.io/tools/codegen. DO NOT EDIT.

package mochi

import (
	"errors"

	crypto "nimona.io/pkg/crypto"
	immutable "nimona.io/pkg/immutable"
	object "nimona.io/pkg/object"
)

type (
	IdentityContact struct {
		raw            object.Object
		Stream         object.Hash
		Parents        []object.Hash
		Owners         []crypto.PublicKey
		Policy         object.Policy
		Signatures     []object.Signature
		Alias          string
		PublicKey      crypto.PublicKey
		Profile        *IdentityProfile
		CreateDatetime string
	}
	IdentityProfile struct {
		raw            object.Object
		Stream         object.Hash
		Parents        []object.Hash
		Owners         []crypto.PublicKey
		Policy         object.Policy
		Signatures     []object.Signature
		DisplayPicture []byte
		NameFirst      string
		NameLast       string
		Version        int64
	}
	ConversationCreated struct {
		raw        object.Object
		Stream     object.Hash
		Parents    []object.Hash
		Owners     []crypto.PublicKey
		Policy     object.Policy
		Signatures []object.Signature
		Datetime   string
		Name       string
		Topic      string
		Nonce      string
	}
	ConversationMessageAdded struct {
		raw        object.Object
		Stream     object.Hash
		Parents    []object.Hash
		Owners     []crypto.PublicKey
		Policy     object.Policy
		Signatures []object.Signature
		Datetime   string
		Body       string
	}
	ConversationParticipantInvited struct {
		raw        object.Object
		Stream     object.Hash
		Parents    []object.Hash
		Owners     []crypto.PublicKey
		Policy     object.Policy
		Signatures []object.Signature
		Datetime   string
		PublicKey  crypto.PublicKey
	}
	ConversationParticipantJoined struct {
		raw        object.Object
		Stream     object.Hash
		Parents    []object.Hash
		Owners     []crypto.PublicKey
		Policy     object.Policy
		Signatures []object.Signature
		Datetime   string
	}
	ConversationParticipantProfileUpdated struct {
		raw        object.Object
		Stream     object.Hash
		Parents    []object.Hash
		Owners     []crypto.PublicKey
		Policy     object.Policy
		Signatures []object.Signature
		Datetime   string
		Profile    *IdentityProfile
	}
	StreamPolicy struct {
		raw        object.Object
		Stream     object.Hash
		Parents    []object.Hash
		Owners     []crypto.PublicKey
		Policy     object.Policy
		Signatures []object.Signature
		Datetime   string
	}
	StreamPolicyAdded struct {
		raw        object.Object
		Stream     object.Hash
		Parents    []object.Hash
		Owners     []crypto.PublicKey
		Policy     object.Policy
		Signatures []object.Signature
		Datetime   string
	}
	StreamSubscriptionAdded struct {
		raw        object.Object
		Stream     object.Hash
		Parents    []object.Hash
		Owners     []crypto.PublicKey
		Policy     object.Policy
		Signatures []object.Signature
		Datetime   string
		Topic      string
	}
)

func (e IdentityContact) GetType() string {
	return "nimona.io/identity.Contact"
}

func (e IdentityContact) GetSchema() *object.SchemaObject {
	return &object.SchemaObject{
		Properties: []*object.SchemaProperty{
			&object.SchemaProperty{
				Name:       "alias",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
			&object.SchemaProperty{
				Name:       "publicKey",
				Type:       "nimona.io/crypto.PublicKey",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
			&object.SchemaProperty{
				Name:       "profile",
				Type:       "nimona.io/identity.Profile",
				Hint:       "o",
				IsRepeated: false,
				IsOptional: false,
			},
			&object.SchemaProperty{
				Name:       "createDatetime",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
		},
	}
}

func (e IdentityContact) ToObject() object.Object {
	o := object.Object{}
	o = o.SetType("nimona.io/identity.Contact")
	if len(e.Stream) > 0 {
		o = o.SetStream(e.Stream)
	}
	if len(e.Parents) > 0 {
		o = o.SetParents(e.Parents)
	}
	if len(e.Owners) > 0 {
		o = o.SetOwners(e.Owners)
	}
	o = o.AddSignature(e.Signatures...)
	o = o.SetPolicy(e.Policy)
	if e.Alias != "" {
		o = o.Set("alias:s", e.Alias)
	}
	if e.PublicKey != "" {
		o = o.Set("publicKey:s", e.PublicKey)
	}
	if e.Profile != nil {
		o = o.Set("profile:o", e.Profile.ToObject().Raw())
	}
	if e.CreateDatetime != "" {
		o = o.Set("createDatetime:s", e.CreateDatetime)
	}
	// if schema := e.GetSchema(); schema != nil {
	// 	m["_schema:o"] = schema.ToObject().ToMap()
	// }
	return o
}

func (e *IdentityContact) FromObject(o object.Object) error {
	data, ok := o.Raw().Value("data:o").(immutable.Map)
	if !ok {
		return errors.New("missing data")
	}
	e.raw = object.Object{}
	e.raw = e.raw.SetType(o.GetType())
	e.Stream = o.GetStream()
	e.Parents = o.GetParents()
	e.Owners = o.GetOwners()
	e.Signatures = o.GetSignatures()
	e.Policy = o.GetPolicy()
	if v := data.Value("alias:s"); v != nil {
		e.Alias = string(v.PrimitiveHinted().(string))
	}
	if v := data.Value("publicKey:s"); v != nil {
		e.PublicKey = crypto.PublicKey(v.PrimitiveHinted().(string))
	}
	if v := data.Value("profile:o"); v != nil {
		es := &IdentityProfile{}
		eo := object.FromMap(v.PrimitiveHinted().(map[string]interface{}))
		es.FromObject(eo)
		e.Profile = es
	}
	if v := data.Value("createDatetime:s"); v != nil {
		e.CreateDatetime = string(v.PrimitiveHinted().(string))
	}
	return nil
}

func (e IdentityProfile) GetType() string {
	return "nimona.io/identity.Profile"
}

func (e IdentityProfile) GetSchema() *object.SchemaObject {
	return &object.SchemaObject{
		Properties: []*object.SchemaProperty{
			&object.SchemaProperty{
				Name:       "displayPicture",
				Type:       "data",
				Hint:       "d",
				IsRepeated: false,
				IsOptional: false,
			},
			&object.SchemaProperty{
				Name:       "nameFirst",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
			&object.SchemaProperty{
				Name:       "nameLast",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
			&object.SchemaProperty{
				Name:       "version",
				Type:       "int",
				Hint:       "i",
				IsRepeated: false,
				IsOptional: false,
			},
		},
	}
}

func (e IdentityProfile) ToObject() object.Object {
	o := object.Object{}
	o = o.SetType("nimona.io/identity.Profile")
	if len(e.Stream) > 0 {
		o = o.SetStream(e.Stream)
	}
	if len(e.Parents) > 0 {
		o = o.SetParents(e.Parents)
	}
	if len(e.Owners) > 0 {
		o = o.SetOwners(e.Owners)
	}
	o = o.AddSignature(e.Signatures...)
	o = o.SetPolicy(e.Policy)
	if len(e.DisplayPicture) != 0 {
		o = o.Set("displayPicture:d", e.DisplayPicture)
	}
	if e.NameFirst != "" {
		o = o.Set("nameFirst:s", e.NameFirst)
	}
	if e.NameLast != "" {
		o = o.Set("nameLast:s", e.NameLast)
	}
	o = o.Set("version:i", e.Version)
	// if schema := e.GetSchema(); schema != nil {
	// 	m["_schema:o"] = schema.ToObject().ToMap()
	// }
	return o
}

func (e *IdentityProfile) FromObject(o object.Object) error {
	data, ok := o.Raw().Value("data:o").(immutable.Map)
	if !ok {
		return errors.New("missing data")
	}
	e.raw = object.Object{}
	e.raw = e.raw.SetType(o.GetType())
	e.Stream = o.GetStream()
	e.Parents = o.GetParents()
	e.Owners = o.GetOwners()
	e.Signatures = o.GetSignatures()
	e.Policy = o.GetPolicy()
	if v := data.Value("displayPicture:d"); v != nil {
		e.DisplayPicture = []byte(v.PrimitiveHinted().([]byte))
	}
	if v := data.Value("nameFirst:s"); v != nil {
		e.NameFirst = string(v.PrimitiveHinted().(string))
	}
	if v := data.Value("nameLast:s"); v != nil {
		e.NameLast = string(v.PrimitiveHinted().(string))
	}
	if v := data.Value("version:i"); v != nil {
		e.Version = int64(v.PrimitiveHinted().(int64))
	}
	return nil
}

func (e ConversationCreated) GetType() string {
	return "mochi.io/conversation.Created"
}

func (e ConversationCreated) GetSchema() *object.SchemaObject {
	return &object.SchemaObject{
		Properties: []*object.SchemaProperty{
			&object.SchemaProperty{
				Name:       "datetime",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
			&object.SchemaProperty{
				Name:       "name",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
			&object.SchemaProperty{
				Name:       "topic",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
			&object.SchemaProperty{
				Name:       "nonce",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
		},
	}
}

func (e ConversationCreated) ToObject() object.Object {
	o := object.Object{}
	o = o.SetType("mochi.io/conversation.Created")
	if len(e.Stream) > 0 {
		o = o.SetStream(e.Stream)
	}
	if len(e.Parents) > 0 {
		o = o.SetParents(e.Parents)
	}
	if len(e.Owners) > 0 {
		o = o.SetOwners(e.Owners)
	}
	o = o.AddSignature(e.Signatures...)
	o = o.SetPolicy(e.Policy)
	if e.Datetime != "" {
		o = o.Set("datetime:s", e.Datetime)
	}
	if e.Name != "" {
		o = o.Set("name:s", e.Name)
	}
	if e.Topic != "" {
		o = o.Set("topic:s", e.Topic)
	}
	if e.Nonce != "" {
		o = o.Set("nonce:s", e.Nonce)
	}
	// if schema := e.GetSchema(); schema != nil {
	// 	m["_schema:o"] = schema.ToObject().ToMap()
	// }
	return o
}

func (e *ConversationCreated) FromObject(o object.Object) error {
	data, ok := o.Raw().Value("data:o").(immutable.Map)
	if !ok {
		return errors.New("missing data")
	}
	e.raw = object.Object{}
	e.raw = e.raw.SetType(o.GetType())
	e.Stream = o.GetStream()
	e.Parents = o.GetParents()
	e.Owners = o.GetOwners()
	e.Signatures = o.GetSignatures()
	e.Policy = o.GetPolicy()
	if v := data.Value("datetime:s"); v != nil {
		e.Datetime = string(v.PrimitiveHinted().(string))
	}
	if v := data.Value("name:s"); v != nil {
		e.Name = string(v.PrimitiveHinted().(string))
	}
	if v := data.Value("topic:s"); v != nil {
		e.Topic = string(v.PrimitiveHinted().(string))
	}
	if v := data.Value("nonce:s"); v != nil {
		e.Nonce = string(v.PrimitiveHinted().(string))
	}
	return nil
}

func (e ConversationMessageAdded) GetType() string {
	return "mochi.io/conversation.MessageAdded"
}

func (e ConversationMessageAdded) GetSchema() *object.SchemaObject {
	return &object.SchemaObject{
		Properties: []*object.SchemaProperty{
			&object.SchemaProperty{
				Name:       "datetime",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
			&object.SchemaProperty{
				Name:       "body",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
		},
	}
}

func (e ConversationMessageAdded) ToObject() object.Object {
	o := object.Object{}
	o = o.SetType("mochi.io/conversation.MessageAdded")
	if len(e.Stream) > 0 {
		o = o.SetStream(e.Stream)
	}
	if len(e.Parents) > 0 {
		o = o.SetParents(e.Parents)
	}
	if len(e.Owners) > 0 {
		o = o.SetOwners(e.Owners)
	}
	o = o.AddSignature(e.Signatures...)
	o = o.SetPolicy(e.Policy)
	if e.Datetime != "" {
		o = o.Set("datetime:s", e.Datetime)
	}
	if e.Body != "" {
		o = o.Set("body:s", e.Body)
	}
	// if schema := e.GetSchema(); schema != nil {
	// 	m["_schema:o"] = schema.ToObject().ToMap()
	// }
	return o
}

func (e *ConversationMessageAdded) FromObject(o object.Object) error {
	data, ok := o.Raw().Value("data:o").(immutable.Map)
	if !ok {
		return errors.New("missing data")
	}
	e.raw = object.Object{}
	e.raw = e.raw.SetType(o.GetType())
	e.Stream = o.GetStream()
	e.Parents = o.GetParents()
	e.Owners = o.GetOwners()
	e.Signatures = o.GetSignatures()
	e.Policy = o.GetPolicy()
	if v := data.Value("datetime:s"); v != nil {
		e.Datetime = string(v.PrimitiveHinted().(string))
	}
	if v := data.Value("body:s"); v != nil {
		e.Body = string(v.PrimitiveHinted().(string))
	}
	return nil
}

func (e ConversationParticipantInvited) GetType() string {
	return "mochi.io/conversation.ParticipantInvited"
}

func (e ConversationParticipantInvited) GetSchema() *object.SchemaObject {
	return &object.SchemaObject{
		Properties: []*object.SchemaProperty{
			&object.SchemaProperty{
				Name:       "datetime",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
			&object.SchemaProperty{
				Name:       "publicKey",
				Type:       "nimona.io/crypto.PublicKey",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
		},
	}
}

func (e ConversationParticipantInvited) ToObject() object.Object {
	o := object.Object{}
	o = o.SetType("mochi.io/conversation.ParticipantInvited")
	if len(e.Stream) > 0 {
		o = o.SetStream(e.Stream)
	}
	if len(e.Parents) > 0 {
		o = o.SetParents(e.Parents)
	}
	if len(e.Owners) > 0 {
		o = o.SetOwners(e.Owners)
	}
	o = o.AddSignature(e.Signatures...)
	o = o.SetPolicy(e.Policy)
	if e.Datetime != "" {
		o = o.Set("datetime:s", e.Datetime)
	}
	if e.PublicKey != "" {
		o = o.Set("publicKey:s", e.PublicKey)
	}
	// if schema := e.GetSchema(); schema != nil {
	// 	m["_schema:o"] = schema.ToObject().ToMap()
	// }
	return o
}

func (e *ConversationParticipantInvited) FromObject(o object.Object) error {
	data, ok := o.Raw().Value("data:o").(immutable.Map)
	if !ok {
		return errors.New("missing data")
	}
	e.raw = object.Object{}
	e.raw = e.raw.SetType(o.GetType())
	e.Stream = o.GetStream()
	e.Parents = o.GetParents()
	e.Owners = o.GetOwners()
	e.Signatures = o.GetSignatures()
	e.Policy = o.GetPolicy()
	if v := data.Value("datetime:s"); v != nil {
		e.Datetime = string(v.PrimitiveHinted().(string))
	}
	if v := data.Value("publicKey:s"); v != nil {
		e.PublicKey = crypto.PublicKey(v.PrimitiveHinted().(string))
	}
	return nil
}

func (e ConversationParticipantJoined) GetType() string {
	return "mochi.io/conversation.ParticipantJoined"
}

func (e ConversationParticipantJoined) GetSchema() *object.SchemaObject {
	return &object.SchemaObject{
		Properties: []*object.SchemaProperty{
			&object.SchemaProperty{
				Name:       "datetime",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
		},
	}
}

func (e ConversationParticipantJoined) ToObject() object.Object {
	o := object.Object{}
	o = o.SetType("mochi.io/conversation.ParticipantJoined")
	if len(e.Stream) > 0 {
		o = o.SetStream(e.Stream)
	}
	if len(e.Parents) > 0 {
		o = o.SetParents(e.Parents)
	}
	if len(e.Owners) > 0 {
		o = o.SetOwners(e.Owners)
	}
	o = o.AddSignature(e.Signatures...)
	o = o.SetPolicy(e.Policy)
	if e.Datetime != "" {
		o = o.Set("datetime:s", e.Datetime)
	}
	// if schema := e.GetSchema(); schema != nil {
	// 	m["_schema:o"] = schema.ToObject().ToMap()
	// }
	return o
}

func (e *ConversationParticipantJoined) FromObject(o object.Object) error {
	data, ok := o.Raw().Value("data:o").(immutable.Map)
	if !ok {
		return errors.New("missing data")
	}
	e.raw = object.Object{}
	e.raw = e.raw.SetType(o.GetType())
	e.Stream = o.GetStream()
	e.Parents = o.GetParents()
	e.Owners = o.GetOwners()
	e.Signatures = o.GetSignatures()
	e.Policy = o.GetPolicy()
	if v := data.Value("datetime:s"); v != nil {
		e.Datetime = string(v.PrimitiveHinted().(string))
	}
	return nil
}

func (e ConversationParticipantProfileUpdated) GetType() string {
	return "mochi.io/conversation.ParticipantProfileUpdated"
}

func (e ConversationParticipantProfileUpdated) GetSchema() *object.SchemaObject {
	return &object.SchemaObject{
		Properties: []*object.SchemaProperty{
			&object.SchemaProperty{
				Name:       "datetime",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
			&object.SchemaProperty{
				Name:       "profile",
				Type:       "nimona.io/identity.Profile",
				Hint:       "o",
				IsRepeated: false,
				IsOptional: false,
			},
		},
	}
}

func (e ConversationParticipantProfileUpdated) ToObject() object.Object {
	o := object.Object{}
	o = o.SetType("mochi.io/conversation.ParticipantProfileUpdated")
	if len(e.Stream) > 0 {
		o = o.SetStream(e.Stream)
	}
	if len(e.Parents) > 0 {
		o = o.SetParents(e.Parents)
	}
	if len(e.Owners) > 0 {
		o = o.SetOwners(e.Owners)
	}
	o = o.AddSignature(e.Signatures...)
	o = o.SetPolicy(e.Policy)
	if e.Datetime != "" {
		o = o.Set("datetime:s", e.Datetime)
	}
	if e.Profile != nil {
		o = o.Set("profile:o", e.Profile.ToObject().Raw())
	}
	// if schema := e.GetSchema(); schema != nil {
	// 	m["_schema:o"] = schema.ToObject().ToMap()
	// }
	return o
}

func (e *ConversationParticipantProfileUpdated) FromObject(o object.Object) error {
	data, ok := o.Raw().Value("data:o").(immutable.Map)
	if !ok {
		return errors.New("missing data")
	}
	e.raw = object.Object{}
	e.raw = e.raw.SetType(o.GetType())
	e.Stream = o.GetStream()
	e.Parents = o.GetParents()
	e.Owners = o.GetOwners()
	e.Signatures = o.GetSignatures()
	e.Policy = o.GetPolicy()
	if v := data.Value("datetime:s"); v != nil {
		e.Datetime = string(v.PrimitiveHinted().(string))
	}
	if v := data.Value("profile:o"); v != nil {
		es := &IdentityProfile{}
		eo := object.FromMap(v.PrimitiveHinted().(map[string]interface{}))
		es.FromObject(eo)
		e.Profile = es
	}
	return nil
}

func (e StreamPolicy) GetType() string {
	return "nimona.io/stream.Policy"
}

func (e StreamPolicy) GetSchema() *object.SchemaObject {
	return &object.SchemaObject{
		Properties: []*object.SchemaProperty{
			&object.SchemaProperty{
				Name:       "datetime",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
		},
	}
}

func (e StreamPolicy) ToObject() object.Object {
	o := object.Object{}
	o = o.SetType("nimona.io/stream.Policy")
	if len(e.Stream) > 0 {
		o = o.SetStream(e.Stream)
	}
	if len(e.Parents) > 0 {
		o = o.SetParents(e.Parents)
	}
	if len(e.Owners) > 0 {
		o = o.SetOwners(e.Owners)
	}
	o = o.AddSignature(e.Signatures...)
	o = o.SetPolicy(e.Policy)
	if e.Datetime != "" {
		o = o.Set("datetime:s", e.Datetime)
	}
	// if schema := e.GetSchema(); schema != nil {
	// 	m["_schema:o"] = schema.ToObject().ToMap()
	// }
	return o
}

func (e *StreamPolicy) FromObject(o object.Object) error {
	data, ok := o.Raw().Value("data:o").(immutable.Map)
	if !ok {
		return errors.New("missing data")
	}
	e.raw = object.Object{}
	e.raw = e.raw.SetType(o.GetType())
	e.Stream = o.GetStream()
	e.Parents = o.GetParents()
	e.Owners = o.GetOwners()
	e.Signatures = o.GetSignatures()
	e.Policy = o.GetPolicy()
	if v := data.Value("datetime:s"); v != nil {
		e.Datetime = string(v.PrimitiveHinted().(string))
	}
	return nil
}

func (e StreamPolicyAdded) GetType() string {
	return "nimona.io/stream.PolicyAdded"
}

func (e StreamPolicyAdded) GetSchema() *object.SchemaObject {
	return &object.SchemaObject{
		Properties: []*object.SchemaProperty{
			&object.SchemaProperty{
				Name:       "datetime",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
		},
	}
}

func (e StreamPolicyAdded) ToObject() object.Object {
	o := object.Object{}
	o = o.SetType("nimona.io/stream.PolicyAdded")
	if len(e.Stream) > 0 {
		o = o.SetStream(e.Stream)
	}
	if len(e.Parents) > 0 {
		o = o.SetParents(e.Parents)
	}
	if len(e.Owners) > 0 {
		o = o.SetOwners(e.Owners)
	}
	o = o.AddSignature(e.Signatures...)
	o = o.SetPolicy(e.Policy)
	if e.Datetime != "" {
		o = o.Set("datetime:s", e.Datetime)
	}
	// if schema := e.GetSchema(); schema != nil {
	// 	m["_schema:o"] = schema.ToObject().ToMap()
	// }
	return o
}

func (e *StreamPolicyAdded) FromObject(o object.Object) error {
	data, ok := o.Raw().Value("data:o").(immutable.Map)
	if !ok {
		return errors.New("missing data")
	}
	e.raw = object.Object{}
	e.raw = e.raw.SetType(o.GetType())
	e.Stream = o.GetStream()
	e.Parents = o.GetParents()
	e.Owners = o.GetOwners()
	e.Signatures = o.GetSignatures()
	e.Policy = o.GetPolicy()
	if v := data.Value("datetime:s"); v != nil {
		e.Datetime = string(v.PrimitiveHinted().(string))
	}
	return nil
}

func (e StreamSubscriptionAdded) GetType() string {
	return "nimona.io/stream.SubscriptionAdded"
}

func (e StreamSubscriptionAdded) GetSchema() *object.SchemaObject {
	return &object.SchemaObject{
		Properties: []*object.SchemaProperty{
			&object.SchemaProperty{
				Name:       "datetime",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
			&object.SchemaProperty{
				Name:       "topic",
				Type:       "string",
				Hint:       "s",
				IsRepeated: false,
				IsOptional: false,
			},
		},
	}
}

func (e StreamSubscriptionAdded) ToObject() object.Object {
	o := object.Object{}
	o = o.SetType("nimona.io/stream.SubscriptionAdded")
	if len(e.Stream) > 0 {
		o = o.SetStream(e.Stream)
	}
	if len(e.Parents) > 0 {
		o = o.SetParents(e.Parents)
	}
	if len(e.Owners) > 0 {
		o = o.SetOwners(e.Owners)
	}
	o = o.AddSignature(e.Signatures...)
	o = o.SetPolicy(e.Policy)
	if e.Datetime != "" {
		o = o.Set("datetime:s", e.Datetime)
	}
	if e.Topic != "" {
		o = o.Set("topic:s", e.Topic)
	}
	// if schema := e.GetSchema(); schema != nil {
	// 	m["_schema:o"] = schema.ToObject().ToMap()
	// }
	return o
}

func (e *StreamSubscriptionAdded) FromObject(o object.Object) error {
	data, ok := o.Raw().Value("data:o").(immutable.Map)
	if !ok {
		return errors.New("missing data")
	}
	e.raw = object.Object{}
	e.raw = e.raw.SetType(o.GetType())
	e.Stream = o.GetStream()
	e.Parents = o.GetParents()
	e.Owners = o.GetOwners()
	e.Signatures = o.GetSignatures()
	e.Policy = o.GetPolicy()
	if v := data.Value("datetime:s"); v != nil {
		e.Datetime = string(v.PrimitiveHinted().(string))
	}
	if v := data.Value("topic:s"); v != nil {
		e.Topic = string(v.PrimitiveHinted().(string))
	}
	return nil
}
