package domain

import (
	"testing"
)

func TestInitialLetter(t *testing.T) {
	t.Parallel()
	type args struct {
		str string
	}
	tests := []struct {
		name    string
		args    args
		want    InitialLetterType
		want1   string
		wantErr bool
	}{
		{
			name:    "記号",
			args:    args{str: "<echo>PROJECT"},
			want:    InitialLetterTypeSymbol,
			want1:   "",
			wantErr: false,
		},
		// ... (other test cases) ...
		{
			name:    "その他",
			args:    args{str: "α music"},
			want:    InitialLetterTypeOther,
			want1:   "",
			wantErr: false,
		},
		{
			name:    "空文字列",
			args:    args{str: ""},
			want:    "",
			want1:   "",
			wantErr: true,
		},
	}
	for _, tt := range tests {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()
			got, got1, err := InitialLetter(tt.args.str)
			if (err != nil) != tt.wantErr {
				t.Errorf("InitialLetter() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if got != tt.want {
				t.Errorf("InitialLetter() got = %v, want %v", got, tt.want)
			}
			if got1 != tt.want1 {
				t.Errorf("InitialLetter() got1 = %v, want %v", got1, tt.want1)
			}
		})
	}
}
