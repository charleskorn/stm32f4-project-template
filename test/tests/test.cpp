#include "bandit/bandit.h"

using namespace bandit;

go_bandit([]() {
    describe("Addition", []() {
        it("calculates 0 + 0", []() {
            AssertThat(0 + 0, Equals(0));
        });

        it("calculates 0 + 1", []() {
            AssertThat(0 + 1, Equals(1));
        });
    });
});
