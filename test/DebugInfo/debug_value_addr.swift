// RUN: %target-swift-frontend -primary-file %s -emit-ir -g -o - | FileCheck %s
// RUN: %target-swift-frontend %s -emit-sil -g -o - | FileCheck -check-prefix=CHECK-SIL %s

// Verify that -Onone shadow copies are emitted for debug_value_addr
// instructions.

// CHECK-SIL: sil hidden @_TF16debug_value_addr4testurFq_T_
// CHECK-SIL: debug_value_addr %0 : $*T  // let t

// CHECK: define {{.*}}_TF16debug_value_addr4testurFq_T_
// CHECK: entry:
// CHECK-NEXT: %[[TADDR:.*]] = alloca
// CHECK: store %swift.opaque* %0, %swift.opaque** %[[TADDR:.*]],
// CHECK-NEXT: call void @llvm.dbg.declare({{.*}}%[[TADDR]],
// CHECK-SAME:                             {{.*}}, metadata ![[EXPR:.*]])
// CHECK: ![[EXPR]] = !DIExpression(DW_OP_deref)
struct S<T> {
  var a : T
  func foo() {}
}

func test<T>(t : T) {
  let a = S(a: t )
  a.foo()
}
