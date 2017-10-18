<?php // ###php-mode-test### ((indent (* 0 c-basic-offset)))
// ###php-mode-test### ((indent 0))

/**                 // ###php-mode-test### ((indent 0))
 * Block namespace  // ###php-mode-test### ((indent 1))
 */                 // ###php-mode-test### ((indent 1))
namespace FooBar // ###php-mode-test### ((indent 0))
{                // ###php-mode-test### ((indent 0))
    $i = 0;      // ###php-mode-test### ((indent c-basic-offset))
    do {         // ###php-mode-test### ((indent c-basic-offset))
        $i++;    // ###php-mode-test### ((indent (* 2 c-basic-offset)))
    } while ($i < 100); // ###php-mode-test### ((indent c-basic-offset))
    // ###php-mode-test### ((indent c-basic-offset))
    try {                             // ###php-mode-test### ((indent c-basic-offset))
        throw new \RuntimeException;  // ###php-mode-test### ((indent (* 2 c-basic-offset)))
    } catch (\Error $e) {             // ###php-mode-test### ((indent c-basic-offset))
        echo "cached error", PHP_EOL; // ###php-mode-test### ((indent (* 2 c-basic-offset)))
    } catch (Error $e) {              // ###php-mode-test### ((indent c-basic-offset))
        echo "cached error", PHP_EOL; // ###php-mode-test### ((indent (* 2 c-basic-offset)))
    } finally {                       // ###php-mode-test### ((indent c-basic-offset))
        echo "finally", PHP_EOL;      // ###php-mode-test### ((indent (* 2 c-basic-offset)))
    }                                 // ###php-mode-test### ((indent c-basic-offset))
    // ###php-mode-test### ((indent c-basic-offset))
    /**              // ###php-mode-test### ((indent c-basic-offset))
     * DocComment    // ###php-mode-test### ((indent (1+ c-basic-offset)))
     */              // ###php-mode-test### ((indent (1+ c-basic-offset)))
    function hoge()  // ###php-mode-test### ((indent c-basic-offset))
    {                // ###php-mode-test### ((indent c-basic-offset))
        // ###php-mode-test### ((indent (* 2 c-basic-offset)))
    }                // ###php-mode-test### ((indent c-basic-offset))
    // ###php-mode-test### ((indent c-basic-offset))
    function fuga() :array // ###php-mode-test### ((indent c-basic-offset))
    {                      // ###php-mode-test### ((indent c-basic-offset))
    }                      // ###php-mode-test### ((indent c-basic-offset))
    // ###php-mode-test### ((indent c-basic-offset))
    // ###php-mode-test### ((indent c-basic-offset))
    class Fizz             // ###php-mode-test### ((indent c-basic-offset))
    {                      // ###php-mode-test### ((indent c-basic-offset))
        static             // ###php-mode-test### ((indent (* 2 c-basic-offset)))
            public         // ###php-mode-test### ((indent (* 3 c-basic-offset)))
            function a(    // ###php-mode-test### ((indent (* 3 c-basic-offset)))
                array $v   // ###php-mode-test### ((indent (* 4 c-basic-offset)))
            ):             // ###php-mode-test### ((indent (* 3 c-basic-offset)))
            string         // ###php-mode-test### ((indent (* 3 c-basic-offset)))
        {                  // ###php-mode-test### ((indent (* 2 c-basic-offset)))
            return         // ###php-mode-test### ((indent (* 3 c-basic-offset)))
                array_pop( // ###php-mode-test### ((indent (* 4 c-basic-offset)))
                    $v     // ###php-mode-test### ((indent (* 5 c-basic-offset)))
                )          // ###php-mode-test### ((indent (* 4 c-basic-offset)))
                ;          // ###php-mode-test### ((indent (* 4 c-basic-offset)))
        }                  // ###php-mode-test### ((indent (* 2 c-basic-offset)))
    }                      // ###php-mode-test### ((indent c-basic-offset))
    // ###php-mode-test### ((indent c-basic-offset))
    class Buzz            // ###php-mode-test### ((indent c-basic-offset))
        extends           // ###php-mode-test### ((indent (* 2 c-basic-offset)))
        Fizz              // ###php-mode-test### ((indent (* 2 c-basic-offset)))
    {                     // ###php-mode-test### ((indent c-basic-offset))
        function b // ###php-mode-test### ((indent (* 2 c-basic-offset)))
            (             // ###php-mode-test### ((indent (* 3 c-basic-offset)))
                $v        // ###php-mode-test### ((indent (* 4 c-basic-offset)))
            ) {           // ###php-mode-test### ((indent (* 3 c-basic-offset)))
            while         // ###php-mode-test### ((indent (* 3 c-basic-offset)))
                (         // ###php-mode-test### ((indent (* 4 c-basic-offset)))
                    true  // ###php-mode-test### ((indent (* 5 c-basic-offset)))
                )         // ###php-mode-test### ((indent (* 4 c-basic-offset)))
            {             // ###php-mode-test### ((indent (* 3 c-basic-offset)))
                yield     // ###php-mode-test### ((indent (* 4 c-basic-offset)))
                    1;    // ###php-mode-test### ((indent (* 5 c-basic-offset)))
            }             // ###php-mode-test### ((indent (* 3 c-basic-offset)))
        } // ###php-mode-test### ((indent (* 2 c-basic-offset)))
    } // ###php-mode-test### ((indent (* 1 c-basic-offset)))
}     // ###php-mode-test### ((indent (* 0 c-basic-offset)))

// ###php-mode-test### ((indent (* 0 c-basic-offset)))
